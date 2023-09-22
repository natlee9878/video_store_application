// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"
document.addEventListener("DOMContentLoaded", function() {
    const editor = document.querySelector('#editor');
    const hiddenInput = document.querySelector('#hidden-description');
    const quill = new Quill(editor, {
        theme: 'snow'
    });

    // Update hidden textarea with editor's content when it changes
    quill.on('text-change', function() {
        hiddenInput.value = quill.root.innerHTML;
    });
});