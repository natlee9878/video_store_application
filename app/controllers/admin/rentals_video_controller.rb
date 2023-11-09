class RentalsVideo < ApplicationRecord
  after_create :deduct_stock
  has_one :notification_request


  private
  def overdue?
    return_date < Date.today
  end
end