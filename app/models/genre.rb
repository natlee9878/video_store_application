# app/models/genre.rb
class Genre < ApplicationRecord
  has_and_belongs_to_many :videos

  scope :search_by_name, ->(name) {
    where("name LIKE :name", name: "%#{name}%")
  }
  humanize :active, boolean: true
  scope :active_status, -> (status) { where(active: status) if status.present? }
end