// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

//= require rails_sortable
// require bootstrap-editable
// require bootstrap-editable-rails
//= require dark-editable
//= require quick_edit
//= require jquery_nested_form
//= require spin
//= require jquery.spin
//= require password_meter
//= require modal
//= require partial_refresh
//= require multiselect
//= require rails.validations
//= require rails.validations.simple_form
//= require client_side_select2
//= require back_to_top
//= require select
//= require cookie
//= require flash_message
//= require portlets
//= require_tree ./mvi/
//= require froala_editor.min.js

$(document).on('turbolinks:load', function() {
    $('#my-editor').froalaEditor()
});
$(document).ajaxComplete(function () {
    setTimeout(function () {
        $('form[data-client-side-validations]').enableClientSideValidations();
    }, 500);
    $('.tableFloatingHeaderOriginal').css('padding-top', $('#navbar').height());
    // To avoid number input value gets changed when someone scroll using mouse wheel on QE Form
    $('input[type=number]').on('wheel', function (e) {
        $(this).blur();
    });
});

$(document).ready(function () {
    updateKanban();
    updateUploaders();
    $(".kanban-table").attachDragger();
    Flash.init();
    QuickEdit.config.confirmOnClose = false;
    QuickEdit.flash = function (type, message) {
        if (type == 'error') {
            Flash.create(type, message);
        }
    };
    $('.tableFloatingHeaderOriginal').css('padding-top', $('#navbar').height());
    // To avoid number input value gets changed when someone scroll using mouse wheel on Form
    $('input[type=number]').on('wheel', function (e) {
        $(this).blur();
    });
    //js code starts
    //js code ends
});

//code that needs to work both on document load and on ajax complete due to how the portlets and modal works
function applicationCode() {
    $(function () {
        $('tbody.sortable').railsSortable();
    });

    if ( $.isFunction($.fn.select2) ) {
        //Fixes issue with BS5 modal close event disabling select2 inputs
        var myModalEl = document.getElementById('myModal')
        myModalEl.addEventListener('hidden.bs.modal', function (event) {
            selectHandling();
        })
    }

    $(document).on('select2:open', () => {
        document.querySelector('.select2-search__field').focus();
    });

    $('.modal').on('show.bs.modal', function (e) {
        $(this).removeAttr('tabindex');
    })

    $('.print-btn-js').on('click', function () {
        printData($(this).data('table'));
    });

    $('.multiselect').multiselect();
    var form = $('.multiselect').closest('form');
    form.on('submit', function () {
        // Anything in the appropriate select box is intended to be selected.
        // We make sure of that here.
        form.find('.multiselect_to').find('option').prop('selected', true);
        // Submit the form as per normal.
        return;
    });

    $('#menu-topnav').click(function () {
        if ($("body").hasClass("hidden-menu")) {
            $("body").removeClass("hidden-menu");
        } else {
            $("body").addClass("hidden-menu");
        }
    });

    $('.site-overlay').click(function () {
        if ($("body").hasClass("hidden-menu")) {
            $("body").removeClass("hidden-menu");
        } else {
            $("body").addClass("hidden-menu");
        }
    });

    $('.clear-btn').click(function() {
        $("input[type='date']").val('0000-00-00');
    });

    froalaSetup();

    var mosaicoDataElem = $('#mosaico');
    var backButton = mosaicoDataElem.data('template-link');
    var tokenList = mosaicoDataElem.data('token-list');
    if (backButton === undefined) {
        backButton = '<a class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary"' +
            'href="/email_templates">' +
            "<span class='ui-button-icon-primary ui-icon fa fa-fw fa-arrow-left'></span>" +
            "<span class='ui-button-text'>Back</span></a>"
    }
    setTimeout(function() {
        $('#page #toolbar .rightButtons').prepend(backButton);
        if (tokenList !== undefined && tokenList !== null && tokenList.length > 0) {
            $('#page #main-toolbox #tooltabs #toolcontents .editor').append(
                '<div class="objEdit level0"><span class="objLabel level0"><span>Available Tokens</span></span>' +
                '<div class="propEditor">' + tokenList + '</div></div>'
            );
        }
    }, 1000);


}

function printData(table) {
    var divToPrint = document.getElementsByClassName(table);
    newWin = window.open("");
    newWin.document.write(divToPrint[0].outerHTML);
    newWin.print();
    newWin.close();
}

$(document).ready(applicationCode);
$(document).ajaxComplete(applicationCode);

$(document).on('nested:fieldAdded', function() {
    updateKanban();
    updateUploaders();
    applicationCode();
});


$(document).on('ajax:success', 'a.action-button', function (event, xhr, settings) {
    Flash.create(xhr['type'], xhr['message']);
});

$(document).on('click', '.dropbtn', function () {
    $(this).parent().find('#mvi-dropdown-btn-js').toggle("show");
});

$(document).on('click', '.viewer-chevron', function () {
    const heading = $(this).closest('.tree-heading')
    const rows = heading.closest('table').find('.tree-parent-' + heading.data('tree-parent'));
    rows.toggleClass('hidden-row');
    rows.toggleClass('unhidden-row');
    heading.closest('tr').find('.viewer-chevron').find('i').toggleClass("fa-minus-square fa-plus-square");
});

// $.fn.editable.defaults.mode = 'inline';
// $.fn.editable.defaults.showbuttons = false;
// $.fn.editable.defaults.onblur = 'submit';
// $.fn.editable.defaults.ajaxOptions = {type: "PUT"};
// $(document).on('ready ajaxSuccess ajaxComplete', function () {
//   $('.editable_column').editable();
//   $('.editable_column').closest('table').addClass('inline-edit-table');
// });

// To save the date after changing it with editable input date type as current inline-editing is not
// really saving after change
$(document).on('change', '.picker__input', function () {
    var editable = $(this).closest('.editable-container').prev('.editable-open');
    if (editable.length > 0) {
        var resource = $(editable).data('resource');
        var attribute = $(editable).data('name');
        var url = $(editable).data('url');
        var value = $(this).val();
        if (!!url && !!value) {
            var data = {};
            var attributes = {};
            attributes[attribute] = value;
            data[resource] = attributes;
            $.ajax({
                url: url,
                data: data,
                type: 'PUT',
                success: function () {
                    var compact_date = value.replace(/([A-Za-z]{3}\s)([0-9]{2})/, '\$1');
                    $(editable).html(compact_date);
                }
            });
        }
    }
});

// Set up add new and export buttons on the bottom of filter row on tabbed list to follow the screen size and
// update it every time we open the tab
$(document).on('load ajaxComplete mouseup', '.nav-tabs li', function () {
    setTimeout(function () {
        $('div.tab-content .non-list-tab').each(function (index) {
            var height = $(this).find('.filter-button-control').height() - 33;
            if (height > 0) {
                $(this).find('.mvi-ibox-title').css('top', height);
            }
        });
    }, 200);
});

// To set tabbed form error handling
$(document).on('ajax:error ajaxComplete ready', function () {
    if ($('.nav-tabs').length > 0) {
        var first_error = true;
        $('.mvi-form-content .tab-content').children('.tab-pane').each(function (index) {
            var name = $(this).attr('id');
            var error_count = $(this).find('span.error').length;
            if (error_count > 0) {
                $('.' + name + ' span.error-form-label').html(error_count);
                $('.' + name).addClass('tab-error-border');

                if (first_error) {
                    $('.mvi-form-content .nav-tabs li').removeClass('active');
                    $('.mvi-form-content .tab-content .tab-pane').removeClass('in active');

                    $('#' + name).addClass('in active');
                    $('.' + name).addClass('active');
                    first_error = false;
                }
            }
        });
    }
});

$(document).on('click', '.single-show-edit', function () {
    $.get($(this).data('form-url'), {single_show_edit: true}, function (content) {
        $('#main-content').html(content);
    });
    return false;
});

$(document).on('click', 'a[href="#"]', function (e) {
    e.preventDefault();
});

function updateKanban() {
    $(".kanban_column").sortable({
        connectWith: ".kanban_column",
        update: function (event, ui) {
            var new_value = ui.item.prev().parent().attr('id').toString();
            var object_id = ui.item[0].id;
            var url = object_id.toString();
            var kanban_group = $(".kanban_body").attr('kanban_group');
            var model = $(".kanban_body").attr('model');
            var data = '{ "' + model + '":{ "' + kanban_group + '":"' + new_value + '"}}';
            $.ajax({
                type: "PUT",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('X-CSRF-Token',
                        $('meta[name="csrf-token"]').attr('content'))
                },
                url: url,
                data: JSON.parse(data),
                error: function (hhr) {
                    $('#myModal .modal-content').html(hhr.responseText);
                    $('#myModal').modal('show');
                }
            });
        }
    });
};

$.fn.attachDragger = function () {
    var attachment = false, lastPosition, position, difference;
    $($(this).selector).on("mousedown mouseup mousemove", function (e) {

        var mouseClass = 0;
        if (e.type == "mousedown") {
            mouseClass = $(e.target).parent().attr('class') || 0;
        }

        if (!mouseClass) {
            if (e.type == "mousedown") attachment = true, lastPosition = [e.clientX, e.clientY];
            if (e.type == "mouseup") attachment = false;

            if (e.type == "mousemove" && attachment == true) {
                position = [e.clientX, e.clientY];
                difference = [(position[0] - lastPosition[0]), (position[1] - lastPosition[1])];
                $(this).scrollLeft($(this).scrollLeft() - difference[0]);
                $(this).scrollTop($(this).scrollTop() - difference[1]);
                lastPosition = [e.clientX, e.clientY];
            }
        }
    });

    $(window).on("mouseup", function () {
        attachment = false;
    });
};

$(document).ajaxComplete(function () {
    updateKanban();
    updateUploaders();
    $(".kanban-table").attachDragger();

    // Initialize Datepickers and select2 after nested form additions
    $('.add_nested_fields').on('click', function () {
        setTimeout(function () {
            selectHandling();
        }, 100);
    });
});

function updateUploaders() {
    $(".mvi_upload_input").change(function (event) {
        var preview = $(this).parent().parent().find($(".upload-preview"));
        var input = $(event.currentTarget);
        var file = input[0].files[0];
        var url = window.URL.createObjectURL(file);
        var reader = new FileReader();

        reader.onload = function (e) {
            preview.find('img').attr('src', e.target.result);
            preview.find($('.upload-name')).text(file.name);
            preview.find($('.file-link')).attr('href', url);
            preview.find($('.upload-size')).text((file.size / Math.pow(1024, 2)).toFixed(2) + ' MB');
            preview.parent().find($(".remove_file_input")).val(0);
            preview.show();
        };
        reader.readAsDataURL(file);
    });

    $(".clear-file").on("click", function () {
        var contaier = $(this).closest(".form-group");
        contaier.find($('.mvi_upload_input')).val(null);
        var preview = contaier.find($('.upload-preview'));
        contaier.find($('.remove_file_input')).val(1);
        preview.hide();
    });
};

$(document).ready(function () {

    //Enable bootstrap tooltip
    $('[data-toggle="tooltip"]').tooltip();

    //top Navigation - clicking main menu link
    $('.top-nav a.main-nav-item').click(function () {
        if (!$(this).parent('li').hasClass("active")) {
            //remove active and open classes
            $('.top-nav li').removeClass('active');
            $('.top-nav .ddl-menu').removeClass('open');

            //add new active and open classes
            $(this).parent('li').addClass('active')
            $(this).next('.ddl-menu').addClass("open");

            //remove class of last active link
            if (!$(this).parent('.active').hasClass('dd-list')) {
                $('.top-nav .ddl-menu li a').removeClass('last-active');
            }
        } else if (!$(this).next('.ddl-menu').hasClass("open")) {
            $(this).next('.ddl-menu').addClass("open");
        }
    });

    //top Navigation - clicking opened sub menu link
    $('.ddl-menu a').click(function () {
        //remove class of last active link
        $('.top-nav .ddl-menu li a').removeClass('last-active');
        $('.top-nav .ddl-menu').removeClass('open');
        //add class of current active linke
        $(this).addClass('last-active');
    });

    //top Navigation - close the opened menu when clicked outside
    $(document).on("click", function (e) {
        //to see if not the main top link clicked
        if ($(e.target).closest(".main-nav-item").length === 0) {
            if ($('.dd-list .ddl-menu').hasClass("open")) {
                $('.top-nav .ddl-menu').removeClass('open');
            }
        }
    });

    //date picker
    $('#dtpicker-published').on('change', function () {

        var inputDate = document.getElementById("dtpicker-published").value;

        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May",
            "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        var date = new Date(inputDate)
        date.setDate(date.getDate())
        date = date.getDate() + " " + monthNames[date.getMonth()] + " " + date.getFullYear()
        $('#show-published-date').text(date);
    });

    //file upload
    $(function () {
        $('#bt-upload').click(function () {
            $('#uploadfile').click();
        });
    });

    //Help Modal
    $('.icon-help').click(function () {
        $('#help-modal').modal({
            backdrop: 'static',
            keyboard: false
        });
    });

});
