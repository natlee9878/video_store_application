# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/overdue_rental_notification
  def overdue_rental_notification
    UserMailer.overdue_rental_notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/aggressive_overdue_rental_notification
  def aggressive_overdue_rental_notification
    UserMailer.aggressive_overdue_rental_notification
  end

end
