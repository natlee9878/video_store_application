class Notification < ApplicationRecord
  belongs_to :rentals_video
  scope :active_status, -> (status) { where(status: status) if status.present? }
  humanize :status, boolean: true
end
