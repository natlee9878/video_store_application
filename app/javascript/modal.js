var inModal = false

var Modal = {
  errorShow: false,
  showError: function(message) {
    if (message.length > 0) {
      Flash.create('error', message);
    } else {
      Flash.create('error', 'Cannot execute action. Please try again later.');
    }
    return false;
  },

  submitSuccess: function(form, result) {
    var table = $(form).data('table-id');
    var obj = null;
    try {
      obj = jQuery.parseJSON(result);
    } catch(e) {}
    if (obj !== null && obj !== undefined) {
      if (!Modal.errorShow) {
        Modal.errorShow =  true;
        Modal.showError(obj['error'])
      }
      $(form).find('.mvi-ibox-title').css('background-color', 'red');
    } else {
      $('#myModal').modal('hide');
      if ($(document).find('.ignore_refresh').length == 0) {
        if (result.includes('<tr') && $(table).length > 0) {
          if ($(form).hasClass('edit-form')) {
            $(table).find('.modal-editing').closest('tr').replaceWith(result);
          } else {
            $(table).find('tbody').append(result);
          }
        } else {
          location.reload();
        }
      }
    }
  },

  deleteSuccess: function(form, result) {
    var response = false;
    var table = $(form).data('table-id');
    var obj = null;
    try {
      obj = jQuery.parseJSON(result);
    } catch(e) {}
    if (obj !== null && obj !== undefined) {
      if (!response) {
        response = true;
        Modal.showError(obj['error'])
      }
      $(form).find('.mvi-ibox-title').css('background-color', 'red');
    } else {
      $('#myModal').modal('hide');
      if ($(form).hasClass('edit-form') && $(table).length > 0 && !$(form).hasClass('modal-reload')) {
        $(table).find('.modal-editing').closest('tr').remove();
      } else {
        location.reload();
      }
    }
  }
};

$(document).on('click', 'a.modal-submit, a.modal-delete', function (e) {
  e.preventDefault();
  e.stopImmediatePropagation();
  var currentLink = $(this);
  var currentForm = currentLink.closest('form');
  var obj = null;
  var data = new FormData(currentForm[0]);

  $.ajax({
    url: currentForm.attr('action'),
    type: 'POST',
    enctype: currentForm.attr('enctype'),
    data : data,
    processData: false,
    contentType: false,
    success: function(event, data, xhr){
      if ( currentLink.hasClass('modal-delete')) {
        Modal.deleteSuccess(currentForm, event);
      } else {
        Modal.submitSuccess(currentForm, event);
      }
    },

    error:function(event, data, xhr){
      // forces the validation errors to show up as expected
      currentForm.trigger('submit.rails');
      currentForm.find('.mvi-ibox-title').css('background-color', 'red');
      try {
        var responseText = jQuery.parseJSON(JSON.stringify(data.responseText));
        if (responseText[0] == 'error' ) {
          obj = { error: responseText[1] };
        } else {
          obj = jQuery.parseJSON(data.responseText);
        }
      } catch(e) {}
      if ((obj !== null && obj !== undefined)) {
        Modal.showError(obj['error']);
      } else {
        $('.modal-content').html(event.responseText);
      }
    }
  });
});

$(document).on('click', '.modal-edit', function() {
  $('.modal-editing').removeClass('modal-editing');
  $(this).addClass('modal-editing');
  $(this).closest('tr').addClass('modal-row-editing');
});

$('#myModal').on('hidden.bs.modal', function () {
  $('tr').removeClass('modal-row-editing');
  $('td').removeClass('modal-editing');
});

$(document).keyup(function(e) {
  if (e.which == 27 && $('body').hasClass('modal-open')) {
    $('tr').removeClass('modal-row-editing');
    $('td').removeClass('modal-editing');
  }
});

$(document).click(function(e) {
  if ($(e.target).hasClass('modal') && $('body').hasClass('modal-open')) {
    $('tr').removeClass('modal-row-editing');
    $('td').removeClass('modal-editing');
  }
});

$(document).on('click', '.modal-btn', function() {
  inModal = true
  var url = $(this).data('form-url') || $(this).closest('tr').data('form-url');
  var source = $(this);
  if(url !== undefined) {
    $.get(url, function(data) {
      $('#myModal .modal-content').html( data );
      if ($(source).hasClass('action-button')) {
        $('#myModal .modal-content').find('form').addClass('modal-reload');
      }
      $('#myModal').on('hidden.bs.modal', function() {
        $('tr').removeClass('modal-row-editing');
        $('td').removeClass('modal-editing');
      }).modal('show', {backdrop: 'static', keyboard: false});

      setTimeout( function(){
        $('.btn').removeClass('button--loading');
      }, 1000);

    });
  }
});
