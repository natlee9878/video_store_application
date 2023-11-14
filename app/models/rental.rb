class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_many :rentals_video, foreign_key: :order_number
  accepts_nested_attributes_for :rentals_video, allow_destroy: true
  scope :returned_status, -> (status) { where(returned: status)  if status.present? }
  # scope :overdue, -> { where('return_date < ?', "#{Date.today}") }
  humanize :returned, boolean: true

  def item_titles
    rentals_video.map{ |rental| "#{rental.video.title} - (#{ Stock.format_types.key(rental.format_type.to_i).upcase}) " }.join(' ')
  end

  def calculate_total_cost
    total_cost = 0

    rentals_video.each do |rentals_video|
      # Find the corresponding stock for the rental video
      stock = Stock.find_by(video_id: rentals_video.video_id, format_type: rentals_video.format_type)

      if stock && stock.cost.present? && stock.number_owned.present? && stock.number_owned > 0
        individual_cost = stock.cost / stock.number_owned
        total_cost += individual_cost
      end
    end

    total_cost.round(2)
  end

  def display_rental_details_with_costs
    rental_details = []
    total_cost = 0

    rentals_video.each do |rental_video|
      # Find the corresponding stock for the rental video
      stock = Stock.find_by(video_id: rental_video.video_id, format_type: rental_video.format_type)

      if stock
        title_and_format = "#{rental_video.video.title} - (#{Stock.format_types.key(rental_video.format_type.to_i).upcase})"
        individual_cost = stock.number_owned.present? && stock.number_owned > 0 ? (stock.cost / stock.number_owned).round(2) : 0
        rental_details << "#{title_and_format}: $#{individual_cost}"
        total_cost += individual_cost
      end
    end

    # Append the total cost at the end of the details
    rental_details << "Total Cost: $#{total_cost.round(2)}"
    rental_details.join("\n")
  end

  def self.overdue
    where('return_date < ?', "#{Date.today}")
  end

  def due_today
    return_date == Date.today
  end

  def overdue_by_three_days
    return_date <= 3.days.ago.to_date
  end
end
