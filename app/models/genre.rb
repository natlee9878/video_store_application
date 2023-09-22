# app/models/genre.rb
class Genre < ApplicationRecord
  has_and_belongs_to_many :videos
end