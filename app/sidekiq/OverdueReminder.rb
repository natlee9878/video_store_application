class OverdueReminder
  include Sidekiq::Job

  # def index
  #   respond_to do |format|
  #     format.html
  #     format.pdf do
  #       render pdf: "Posts: #{@rental.order_number}", # filename
  #              template: "overdue_reminder.html.erb",
  #              formats: [:html],
  #              disposition: :inline,
  #              layout: 'pdf'
  #     end
  #   end
  # end
  #
  # def get_html
  #   ActionController::Base.new.render_to_string(template: 'overdue_reminder.pdf.erb',
  #                                               orientation: 'Landscape',
  #                                               page_size: 'Letter',
  #                                               background:'true'
  #   )
  # end
  def perform
    Rental.overdue.each do |rental|
      puts 'OVERDUE ==================================================='
      puts "Processing rental: #{rental.inspect}" # Debug statement
      pdf = generate_pdf(rental)

      if rental.due_today
        UserMailer.overdue_rental_notification(rental, pdf).deliver_later
        puts 'Due Today - Outstanding Order!'
      elsif rental.overdue_by_three_days
        UserMailer.aggressive_overdue_rental_notification(rental, pdf).deliver_later
        puts 'Overdue 3 days - Outstanding Order!'
      end
    end
  end

  def generate_pdf(rental)
    puts "Generating PDF for rental: #{rental.inspect}" # Debug statement
    WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(
        template: 'admin/rentals/overdue_reminder', #issue
        layout: 'mailer',
        formats: [:html],
        encoding: "UTF-8",
        locals: { rental: rental }
      )
    )
  end
end
