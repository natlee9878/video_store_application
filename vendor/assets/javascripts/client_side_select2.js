// Add select2 support
var getSelect2;

ClientSideValidations.selectors.validate_inputs += ', select[data-select2-validate]';

ClientSideValidations.selectors.inputs += ', .select2-container';

getSelect2 = function (element) {
  return $(element).parent().find('select');
};

$.fn.base = window.ClientSideValidations.enablers.input;

window.ClientSideValidations.enablers.input = function (element) {
  var extend;
  extend = function () {
    var $form, $placeholder, $select, binding, event, form, ref, ref1, results;
    if (!$(element).hasClass('select2-container')) {
      return $.fn.base(element);
    } else {
      $placeholder = $(element);
      $select = $placeholder.parent().find('select');
      form = $select[0].form;
      $form = $(form);
      if ($select.attr('data-select2-validate')) {
        ref = {
          'focusout.ClientSideValidations': function () {
            return getSelect2(this).isValid(form.ClientSideValidations.settings.validators);
          }
        };
        for (event in ref) {
          binding = ref[event];
          // only focus event should be handled by placeholder
          $placeholder.on(event, binding);
        }
        ref1 = {
          'change.ClientSideValidations': function () {
            return getSelect2(this).data('changed', true);
          },
          'element:validate:after.ClientSideValidations': function (eventData) {
            return ClientSideValidations.callbacks.element.after(getSelect2(this), eventData);
          },
          'element:validate:before.ClientSideValidations': function (eventData) {
            return ClientSideValidations.callbacks.element.before(getSelect2(this), eventData);
          },
          'element:validate:fail.ClientSideValidations': function (eventData, message) {
            element = $(this);
            return ClientSideValidations.callbacks.element.fail(element, message, function () {
              return form.ClientSideValidations.addError(element, message);
            }, eventData);
          },
          'element:validate:pass.ClientSideValidations': function (eventData) {
            element = $(this);
            return ClientSideValidations.callbacks.element.pass(element, function () {
              return form.ClientSideValidations.removeError(element);
            }, eventData);
          }
        };
        // Callbacks
        results = [];
        for (event in ref1) {
          binding = ref1[event];
          results.push($select.on(event, binding));
        }
        return results;
      }
    }
  };
  return extend();
};
