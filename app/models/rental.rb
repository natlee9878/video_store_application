class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_many :rentals_video, foreign_key: :order_number
  accepts_nested_attributes_for :rentals_video, allow_destroy: true
  scope :returned_status, -> (status) { where(returned: status)  if status.present? }
  humanize :returned, boolean: true
  def item_titles
    rentals_video.map{ |rental| "#{rental.video.title} - (#{ Stock.format_types.key(rental.format_type.to_i).upcase}) " }.join(', ')
  end
end
