class NotificationRequest < ApplicationRecord
  belongs_to :rentals_video

  def set_status
    self.status = rentals_video.overdue? ? 'inactive' : 'active'
  end
end