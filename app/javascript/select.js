(function ($) {
  $.each(['show', 'hide'], function (i, ev) {
    var el = $.fn[ev];
    $.fn[ev] = function () {
      this.trigger(ev);
      return el.apply(this, arguments);
    };
  });
})(jQuery);

function selectHandling() {
  var dropdownContainer = ''
  if (inModal) {
    dropdownContainer = $('#myModal')
    inModal = false
  }

  $('select.select2').each(function () {
    if (!$(this).hasClass('select2-hidden-accessible') && !$(this).data('select2')) {
      var maximum_length = parseInt($(this).data('max-length')) || 50;
      if (parseInt($(this).data('selection-length')) > maximum_length &&
        $(this).data('autocomplete-url') != undefined) {
        var identifier = $(this).data('text-identifier');

        $(this).select2({
          delay: 300,
          minimumInputLength: $(this).data('min-length') || 3,
          escapeMarkup: function (text) {
            return text;
          },
          allowClear: $(this).data('allow-clear') || false,
          placeholder: $(this).data('placeholder') || '',
          dropdownParent: dropdownContainer,
          ajax: {
            url: $(this).data('autocomplete-url'),
            dataType: 'json',
            data: function (params) {
              var queryParameters = {
                query: params.term,
                text_output: (identifier || '') + 'select2-code-identifier'
              };
              return queryParameters;
            },

            formatResult: function (option) {
              return "<option value='" + option.id + "'>" + option.text + "</option>";
            },
            formatSelection: function (option) {
              return option.id;
            },
            processResults: function (data, params) {
              // parse the results into the format expected by Select2
              // since we are using custom formatting functions we do not need to
              // alter the remote JSON data, except to indicate that infinite
              // scrolling can be used
              params.page = params.page || 1;

              return {
                results: data,
                pagination: {
                  more: (params.page * 50) < data.length
                }
              };
            },
            cache: true
          }
        });
      } else {
        $(this).select2({dropdownParent: dropdownContainer});
      }
    }
  });

  $(document).on('select2-open', '.select2', function () {
    var option = $(".select2-results .select2-result-unselectable");
    initialise_option(option);
  });

  // Select2 4.0+
  $(document).on('click', '.select2, .select2-selection__choice__remove', function () {
    setTimeout(function () {
      var option = $('.select2-results__options .select2-results__option[aria-disabled=true]');
      initialise_option(option);
    }, 500);
  });

  $('.select2').on('load ready change', function () {
    inactive_setup($(this));
  });

  //select2 rails < 4.0
  $('.select2-choices').on('change', function () {
    inactive_setup($(this).closest('.select2'));
  });

  $(window).on('load', function () {
    $('.multiselect_to').each(function () {
      inactive_setup($(this));
    });
    $('.select2').each(function () {
      select = $(this);
      value = select.children("option[selected=selected]");
      value.each(function () {
        initialise_data(value, select, this);
      });
      inactive_setup($(this));
    });
    $('.select2-drop').each(function () {
      select = $(this);
      value = select.children("option[selected=selected]");
      value.each(function () {
        initialise_data(value, select, this);
      });
      inactive_setup($(this));
    });
  });

  $('table.table[rel=quick-edit] tr td').on('click', function () {
    $('#quick-edit').on('show', function () {
      // Needs to wait until select2 is initialised
      setTimeout(function () {
        $('.multiselect_to').each(function () {
          inactive_setup($(this));
        });
        $('.select2').each(function () {
          select = $(this);
          value = select.children("option[selected=selected]");
          value.each(function () {
            initialise_data(value, select, this);
          });
          inactive_setup($(this));
        });
        $('.select2-drop').each(function () {
          select = $(this);
          value = select.children("option[selected=selected]");
          value.each(function () {
            initialise_data(value, select, this);
          });
          inactive_setup($(this));
        });
      }, 500);
    });
  });
}

// The new more accurate way of calling $(document).on('ready' in jquery 3
$(document).ready(selectHandling);
$(document).ajaxComplete(selectHandling);

function inactive_setup(select) {
  var inactive = $(select).children("option.inactive-option");
  inactive.each(function () {
    $(this).removeClass('inactive-option');
    $(this).prop('disabled', true);
  });

  $(select).next('span.select2').find('.select2-selection__rendered').css('color', 'black');
  $(select).next('span.select2').find('.select2-selection__rendered .select2-selection__choice').css('color', 'black');

  var value = $(select).children("option[selected=selected]");
  value.each(function () {
    var colour = ($(this).prop('disabled') || $(this).hasClass('inactive_option')) ? 'lightgray' : 'black';

    //Normal Option
    if ($(select).hasClass('multiselect_to')) {
      $("select.multiselect_to option[value='" + $(this).val() + "']").css('color', colour);
      $("select.multiselect_to option[value='" + $(this).val() + "']").prop('disabled', false);
    } else if ($(select).hasClass('.select2-drop')) {
      //select2 rails < 4.0
      $(".select2-results .select2-result-unselectable").css('color', colour);
      $(".select2-results .select2-result-unselectable").addClass('inactive-option');
      $(".select2-results .select2-result").removeClass('select2-disabled');
      $(".select2-search-choice.unused-option").remove();
      $(".select2-search-choice div:contains('" + $(this).text() + "')").css('color', colour);
    } else {
      //select2 rails 4.0+
      $(".select2-selection__rendered[title='" + $(this).text() + "']").css('color', colour);
      $(".select2-selection__rendered .select2-selection__choice[title='" + $(this).text() + "']").css('color', colour);

      //select2 rails < 4.0
      $(".select2-chosen:contains('" + $(this).text() + "')").css('color', colour);
      $(".select2-search-choice.unused-option").remove();
      $(".select2-search-choice div:contains('" + $(this).text() + "')").css('color', colour);
      if ($(this).prop('disabled') || $(this).hasClass('inactive-option')) {
        if ($(".select2-search-choice div:contains('" + $(this).text() + "')").length > 0) {
          $(this).addClass('inactive-option');
          $(this).prop('disabled', false);
        } else {
          $(this).removeClass('inactive-option');
          $(this).prop('disabled', true);
        }
      }
    }
  });
}

function initialise_option(option) {
  option.css('color', 'lightgray');
  option.addClass('inactive-option');
  option.attr('aria-selected', false);
  option.removeAttr('aria-disabled');
  option.addClass('select2-result-selectable');
  option.removeClass('select2-disabled');
}

function initialise_data(value, select, current_value) {
  if ($(value).length == 1 && $('.select2-chosen').length > 0 &&
    $('.select2-chosen').text() == '' && !$(select).prop('multiple')) {
    $('.select2-chosen').text($(value).text());
  } else if ($(value).length >= 1 && $(select).prop('multiple')) {
    colour = ($(current_value).prop('disabled') || $(current_value).hasClass('inactive_option')) ?
      'lightgray' : 'black';
    if ($(".select2-search-choice div:contains('" + $(current_value).text() + "')").length == 0) {
      $('ul.select2-choices').prepend(
        '<li class="select2-search-choice unused-option">' +
        '<div style="color: ' + colour + ';">' + $(current_value).text() + '</div>' +
        '</li>');
    }
  }
}
