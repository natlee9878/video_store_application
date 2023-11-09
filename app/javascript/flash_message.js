var Flash = {
  create: function(type, message) {
    if(message !== undefined) {
      $('#flashes').prepend('<div class="overlay">\n <div class="alert alert-' + type + '">\n' +
        '                    <h2><div class="flash-logo"></div></h2>\n' +
        '                    <div class="content">\n' +
        '                      <div class="col-sm-2 icon-placeholder">\n' +
        '                        <span class="alert-icon alert-' + type + ' %>"></span>\n' +
        '                      </div>\n' +
        '                      <div class="col-sm-10">\n' + message +
        '                      </div>\n' +
        '                      <a class="alert-close btn btn-sm btn-close pull-right">Close</a>\n' +
        '                      <a class="alert-confirm btn btn-sm pull-right" style="display: none;">Confirm</a>\n' +
        '                    </div>\n' +
        '                  </div>\n' +
        '                </div>');
      Flash.init();
    }
  },

  init: function() {
    $('#flashes .alert-close:not(.bound-close)').addClass('bound-close')
      .on('click', Flash.destroy);

    // To make sure flash message disappears after awhile
    // setTimeout(function() {
    //   $("#flashes .alert").fadeOut();
    // }, 5000);
  },

  destroy: function(event) {
    $(event.target).closest('.overlay').remove();
  }
};

