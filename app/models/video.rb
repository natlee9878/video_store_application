class Video < ApplicationRecord
  has_and_belongs_to_many :genres
  has_one_attached :thumbnail
  has_many :stocks
  has_many :actor_videos
  has_many :rentals_videos
  has_many :actors, through: :actor_videos
  has_many :rental
  has_rich_text :description
  humanize :active, boolean: true
  scope :search_by_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  scope :active_status, -> (status) { where(active: status) if status.present? }
  scope :available, -> { where(available_for_rental: true) }
  enum format_type: {
    vhs: 0,
    dvd: 1,
    blu_ray: 2
  }

  def name_with_format
    "#{title} (#{format_type})"
  end

  enum content_rating: { PG: 'PG', G: 'G', PG_13:'PG-13', R:'R', NC_17: 'NC17'}
end