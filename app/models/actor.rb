class Actor < ApplicationRecord
  belongs_to :gender
  has_many :actor_videos
  has_many :videos, through: :actor_videos
end