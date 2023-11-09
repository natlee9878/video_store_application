class Stock < ApplicationRecord
  has_and_belongs_to_many :videos, optional: true
  belongs_to :video
  has_many :rental
  enum format_type: { DVD: 1, Blu_ray: 2, VHS: 3 }
  humanize :active, boolean: true

  # This method will calculate the adjusted number_owned for a specific video and format
  def self.on_hand_method(video_id, format_type)
    Rails.logger.debug "=======================Video ID: #{video_id}==========================="
    Rails.logger.debug "=======================Format Type: #{format_type}==========================="

    stock = Stock.find_by(video_id: video_id, format_type: format_type)
    return nil unless stock  # Return nil if no stock found

    # Count the number of rentals for the given video and format
    rentals_count = RentalsVideo.where(video_id: video_id, format_type: format_type).count

    # Return the adjusted number
    stock.number_owned - rentals_count
  end

  def format_type_humanized
    format_type.humanize
  end
end