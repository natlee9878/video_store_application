class Video < ApplicationRecord
  has_and_belongs_to_many :genres
  has_one_attached :thumbnail
  has_many :stocks
  has_many :actor_videos
  has_many :actors, through: :actor_videos
  has_rich_text :description
end