require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "overdue_rental_notification" do
    mail = UserMailer.overdue_rental_notification
    assert_equal "Overdue rental notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "aggressive_overdue_rental_notification" do
    mail = UserMailer.aggressive_overdue_rental_notification
    assert_equal "Aggressive overdue rental notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
