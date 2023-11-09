function inlineEditing() {
  $('.editable_column').each(function() {
    let editableField = document.getElementById( $(this).attr('id') );
    new DarkEditable(editableField);
  });
}

$(document).ready(function () {
  inlineEditing();
});

$(document).ajaxComplete(function () {
  inlineEditing();
});
