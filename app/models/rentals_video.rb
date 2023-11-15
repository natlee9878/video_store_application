class RentalsVideo < ApplicationRecord
  belongs_to :video
  has_many :notifications
  belongs_to :rental, foreign_key: :order_number, primary_key: :order_number

end