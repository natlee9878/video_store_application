//= require dropzone

function initDropzone() {
  // disable auto discover
  Dropzone.autoDiscover = false;

  // grab our upload form by the mvi dropzone class
  let dropzoneForm = $('#mvi-dropzone-form-js');
  let dropzoneFormElement = document.getElementById('mvi-dropzone-form-js');
  let saveTriggered = false;

  if (dropzoneForm.length && !dropzoneFormElement.dropzone) {
    dropzoneForm.dropzone({

      paramName1: dropzoneForm.data('dropzone-param-1'),
      paramName2: dropzoneForm.data('dropzone-param-2'),
      addRemoveLinks: true,
      dictDefaultMessage: "Drop your images here.",
      autoProcessQueue: true,
      uploadMultiple: true,
      parallelUploads: 6,
      previewsContainer: '#dropzonePreview',
      dictRemoveFile: '',

      // The setting up of the dropzone
      init: function() {
        let myDropzone = this;
        let dropzoneHtmlForm = dropzoneFormElement.querySelector('button[type=submit]');
        let dropzoneModalForm = dropzoneFormElement.querySelector('.modal-submit');

        // First change the button to actually tell Dropzone to process the queue.
        dropzoneFormElement.querySelector('.modal-submit, button[type=submit]').addEventListener("click", function(e) {
          if (myDropzone.getQueuedFiles().length > 0) {
            // Make sure that the form isn't actually being sent.
            e.preventDefault();
            e.stopPropagation();
            saveTriggered = true
            myDropzone.processQueue();
          }
        });

        this.on('successmultiple', function(files, response) {
          // Continues default form handling
          let patchInput = $('#mvi-dropzone-form-js input[name=_method]')
          let formAction = dropzoneForm.attr('action');

          if (response.record_id === null) {
            myDropzone.removeAllFiles(true);
          } else {
            if( !patchInput.length || patchInput.val() !== 'patch' ) {
              dropzoneForm.attr('action', formAction + '/' + response.record_id)
              $(" <input type=\"hidden\" name=\"_method\" value=\"patch\"> ").appendTo('.mvi-form-content');

              dropzoneForm.data('parent-record-id', response.record_id);
              initRemovalHandling();
            }
          }

          if (saveTriggered === true || response.record_id === null) {
            saveTriggered = false
            if (dropzoneHtmlForm !== null) {
              $('.btn-save').trigger('click');
            } else if (dropzoneModalForm !== null) {
              $('.modal-submit').trigger('click');
            }
          }
        });

        this.on('errormultiple', function(files, response) {
          $('.modal-submit').trigger('click');
        });
      }
    });
  }

  // overwrite param handling of dropzone in order to submit as nested form params
  Dropzone.prototype._getParamName = function(n) {
    if (typeof this.options.paramName === "function") {
      return this.options.paramName(n);
    } else {
      n += 6;
      return "" + this.options.paramName1 + (this.options.uploadMultiple ? "[" + n + "]" : "") + this.options.paramName2 + "";
    }
  };
}

function initRemovalHandling() {
  $('.dz-remove').on('click', function () {
    let formRecord = $('#mvi-dropzone-form-js')
    let parentId = formRecord.data('parent-record-id');
    let filename = $(this).closest('.dz-preview').find('.dz-filename');

    $.ajax({
      url: '/cleanup_dropzone_upload',
      data: { record_id: parentId, record_name: filename.text(),
        class_name: formRecord.data('class-name'), attribute_param: formRecord.data('dropzone-param-1') },
      type: 'GET',
    });
  });
}

$(document).ready(function () {
  initDropzone();
});

$(document).ajaxComplete(function () {
  initDropzone();
});
