class Actor < ApplicationRecord
  belongs_to :gender
  has_many :actor_videos
  has_many :videos, through: :actor_videos
  scope :search_by_name, ->(name) {
    where("first_name LIKE :name OR last_name LIKE :name", name: "%#{name}%")
  }
  humanize :active, boolean: true
  scope :filter_by_gender, ->(gender_id) { where(gender_id: gender_id) if gender_id.present? }
  scope :active_status, -> (status) { where(active: status) if status.present? }
  def full_name
    "#{first_name} #{last_name}"
  end
end