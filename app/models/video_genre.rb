# app/models/video_genre.rb
class VideoGenre < ApplicationRecord
  belongs_to :video
  belongs_to :genre
  # other code
end