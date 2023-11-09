class RentalsVideo < ApplicationRecord
  belongs_to :rental, foreign_key: :order_number
  belongs_to :video
end