//= require ace-rails-ap
//= require ace/theme-monokai
//= require ace/mode-ruby

function codeEditorInt() {
  $(document).on('change, keyup', '.ace_text-input', function() {
    var editDiv = $(this).closest('div.code-js');
    var input_text = $(editDiv).parent().find('textarea.code-js[data-editor]') ||
      $(container).find('input.code-js[data-editor]');
    var editor = ace.edit(editDiv[0]);
    $(input_text).val(editor.getSession().getValue());
  });

  ace.require('ace/ext/language_tools');
  // Hook up ACE editor to all text-areas with data-editor attribute
  $('textarea[data-editor], input[data-editor]').not('.code-js').each(function() {
    var textarea = $(this);
    textarea.addClass('code-js');
    var editor_config = textarea.data('editor');
    // Define defaults for more see https://github.com/ajaxorg/ace/wiki/Configuring-Ace
    var config = {
      mode: 'ruby',
      theme: 'xcode',
      selectionStyle: 'text',
      highlightActiveLine: true,
      highlightSelectedWord: true,
      readOnly: false,
      cursorStyle: 'smooth',
      useSoftTabs: true,
      tabSize: 2,
      wrap: false,
      highlightGutterLine: true,
      showInvisibles: true,
      printMargin: 110,
      showLineNumbers: true,
      showGutter: true,
      displayIndentGuides: true,
      fontSize: '12px'//,
      //fontFamily: 'Monaco, Menlo, "Ubuntu Mono", Consolas, source-code-pro, monospace;'// FIXME: Not working,
      // FIXME: need to work out extensions properly and fix cursor alignment
      // FIXME look at whether we can avoid pre-compiling every ace asset
      //enableBasicAutocompletion: true,
      //enableSnippets: true,
      //enableLiveAutocompletion: true
    };
    // Extend
    $.extend(true, config, editor_config);
    // Prepend mode and theme
    config.mode = 'ace/mode/' + config.mode;
    config.theme = 'ace/theme/' + config.theme;
    var editDiv = $('<div>', {
      position: 'absolute',
      width: '100%',
      height: '100px',
      'class': textarea.attr('class'),
      'id': textarea.attr('id') + '_ace'
    }).insertBefore(textarea);
    $('<div>', {
      'id': textarea.attr('id') + '_ace_dragbar',
      'class': "app_editor_dragbar"
    }).insertAfter($('#' + textarea.attr('id') + '_ace'));
    textarea.css('display', 'none');
    var editor = ace.edit(editDiv[0]);
    makeAceEditorResizable(editor);
    editor.getSession().setValue(textarea.val());
    // editor.getSession().setMode('ace/mode/' + config.mode);
    // editor.setTheme('ace/theme/' + config.theme);
    editor.setOptions(config);
    // copy back to textarea on form submit...
    textarea.closest('form').submit(function() {
      textarea.val(editor.getSession().getValue());
    })
  });
}

function textCounter() {
  $('.sms-editor').on("input", function() {
    var currentLength = $(this).val().length;

    $('.counter-js').text(currentLength + " Characters");
  });
}

$(document).ready(function () {
  codeEditorInt();
  textCounter();
});

$(document).ajaxComplete(function () {
  codeEditorInt();
  textCounter()
});
