class UserMailer < ApplicationMailer

  def overdue_rental_notification(rental, pdf)
    @rental = rental
    attachments["overdue_rental_#{rental.id}.pdf"] = pdf
    mail(to: rental.user.email, subject: 'Overdue Rental Reminder')
  end

  def aggressive_overdue_rental_notification(rental, pdf)
    @rental = rental
    attachments["overdue_rental_#{rental.id}.pdf"] = pdf
    mail(to: rental.user.email, subject: 'Urgent: Overdue Rental!')
  end

  # def overdue_rental_notification(rental)
  #   @rental = rental
  #
  #   mail(to: rental.user.email, subject: 'Overdue Rental Reminder')
  # end
  #
  # def aggressive_overdue_rental_notification(rental)
  #   @rental = rental
  #   mail(to: rental.user.email, subject: 'Urgent: Overdue Rental!')
  # end


end