class Notification < ApplicationRecord
  belongs_to :rental
  belongs_to :rentals_video
  delegate :video, to: :rental

end
