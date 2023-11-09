// Based on https://css-tricks.com/password-strength-meter/
function passwordHandling() {

  var strength = {
    0: "Worst",
    1: "Bad",
    2: "Weak",
    3: "Good",
    4: "Strong"
  };
  var password = $('input.user_password');
  var meter = $('#password-strength-meter');
  var text = $('#password-strength-text');
  password.on('input', function () {
    var val = $(this).val();
    var result = zxcvbn(val);
    var score = result.score;

    // Update the password strength meter & disable submit if less than strong
    meter.val(score);
    // TODO set password strength score in tempest input
    $('input.password-btn[type=submit]').attr('disabled', score < 4);
    if (score >= 4) {
      $('input.password-btn[type=submit]').val('Set password');
      password.parent().find('.hint').hide();
    } else {
      $('input.password-btn[type=submit]').val('Strong password required');
      password.parent().find('.hint').show();
    }

    // Update the text indicator
    if (val !== "") {
      var suggestions = result.feedback.suggestions.length > 0 ?
        result.feedback.suggestions :
        (score < 4 ? 'Add one or more random characters to make it strong' : '');
      text.html("Strength: " + "<strong>" + strength[score] + " (" + score + ")" +
        " </strong>" + " " + suggestions + "</span>");
    } else {
      text.html("");
    }
  });
}

$(document).ready(passwordHandling);
$(document).ajaxComplete(passwordHandling);
