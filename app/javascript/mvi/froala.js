function froalaSetup() {
  const froala_elements = $('.froala');
  // Adjusts form for handling froala when froala element is on the page
  // Note this is used on each project because each project has Email Templates
  if (froala_elements.length) {
    var field = froala_elements[0].id;
    var object_id = froala_elements.closest('form').attr('id').replace(/[^0-9]/g, '');
  }

  // FIXME: see below for explanation on Codox issue
  //const codox = new Codox();

  let froala_defaults = {
    // FIXME: dislike key being here, even ENV will be visible though so don't gain security
    key: 'GPD2tA17A1A1A3C2D1sGXh1WWTDSGXYOUKc1KINLe1OC1c1D-17D2E2F2A1E4G1C3B8C7E6==',
    // Image uploader & size handling
    imageUploadURL: '/froala_assets/upload_attachment.json',
    imageUploadMethod: 'POST',
    imageManagerLoadURL: '/froala_assets/attachment_gallery.json',
    imageManagerLoadMethod: 'GET',
    imageManagerDeleteURL: '/froala_assets/delete_attachment.json',
    imageManagerDeleteMethod: 'DELETE',
    filesManagerUploadURL: '/froala_assets/upload_attachment.json',
    fileUploadURL: '/froala_assets/upload_attachment.json',
    imageMaxSize: 1024 * 1024 * 20,
    imageUploadParams: {
      field: field,
      object_id: object_id
    },
    // Toolbar definition
    toolbarButtons: {
      // Key represents the more button from the toolbar.
      moreText: {
        // List of buttons used in the group.
        buttons: ['bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily',
          'fontSize', 'textColor', 'backgroundColor', 'inlineClass', 'inlineStyle', 'clearFormatting'],

            // Alignment of the group in the toolbar.
            align: 'left',

            // By default, 3 buttons are shown in the main toolbar. The rest of them are available when using the more button.
            buttonsVisible: 3
      },

      moreParagraph: {
        buttons: ['alignLeft', 'alignCenter', 'formatOLSimple', 'alignRight', 'alignJustify', 'formatOL',
          'formatUL', 'paragraphFormat', 'paragraphStyle', 'lineHeight', 'outdent', 'indent', 'quote'],
            align: 'left',
            buttonsVisible: 3
      },

      moreRich: {
        buttons: ['insertLink', 'insertImage', 'insertVideo', 'insertTable', 'emoticons', 'fontAwesome',
          'specialCharacters', 'embedly', 'insertHR'],// , 'insertFiles' taken out due to click/drag issue
            align: 'left',
            buttonsVisible: 3
      },

      moreMisc: {
        buttons: ['undo', 'redo', 'fullscreen', 'print', 'getPDF', 'spellChecker', 'selectAll', 'html', 'help'],
            align: 'right',
            buttonsVisible: 2
      }
    },
    inlineStyles: {
      'Big Red': 'font-size: 125%; color: red;', // Example, will be added to the selected element e.g. p,span
    },
    // Note that these need to be replicated wherever content is displayed
    inlineClasses: {
      'fr_highlighted': 'Highlighted', // See froala.css for style definition to match
    },
    paragraphStyles: {
      fr_grey: 'Grey', // See froala.css for style definition to match
          fr_bordered: 'Bordered', // See froala.css for style definition to match
          fr_spaced: 'Spaced', // See froala.css for style definition to match
          fr_uppercase: 'Uppercase' // See froala.css for style definition to match
    },
    tableCellStyles: {
      fr_highlighted: 'Highlighted', // See froala.css for style definition to match
    },
    // Note that these need to be replicated wherever content is displayed
    tableStyles: {
      fr_dashed_borders: 'Dashed Borders', // See froala.css for style definition to match
          fr_alt_rows: 'Alternate rows',
    },
    height: 300,
    videoResponsive: true,
    fontFamily: {
      "'Open Sans',sans-serif": 'Open Sans' // Make sure Fonts are included in layout for admin and usage
    },
    fontFamilySelection: true,
    attribution: false, // Remove Powered By Froala
    //linkAttributes: { target: '_blank' }, An attempt at defaulting links to open in new tab
    //imagePasteProcess: true Tried this for fixing pasting image from mail but didn't help
    //pluginsEnabled: [], Specifying only those we use didn't help with load or reduce size by enough and we
    // use most
    // Implementing Codox Live Editing
    // FIXME: there is an issue when using Codox with image upload (same in Froala's demo), images upload
    //  but then disappear, we suspect something to do with the way Codox is reloading the content
    // events: {
    //   //setting up on initialization event
    //   'initialized': function() {
    //     // Codox configuration
    //     let config = {
    //       'app'      : 'froala',
    //       'docId'    : appTitle + '-' + object_id,
    //       'username' : username,
    //       'editor'   : editor,
    //       'apiKey'   : '42b9235b-3cf0-43ab-9c3c-093f10581c0b', //replace this
    //     };
    //
    //     codox.init(config);
    //   }
    // }
  };

  // Note deliberately avoiding a deep merge with $.extend(true, so can overwrite defaults
  // To overwrite any of the above per project simply define let froala_app_options = { };
  let froala_options = typeof froala_app_options != "undefined" ? { ...froala_defaults, ...froala_app_options } : froala_defaults;
  const editor = new FroalaEditor('.froala', froala_options);

  const froala_inputs = froala_elements.closest('.input');
  froala_inputs.resizable({
    containment: '.mvi-form-content',
    minWidth: 400
  });
  froala_inputs.resize(function () {
    $(this).find('.fr-wrapper').css('height', parseInt($(this).css('height')) - 90);
  });
}
