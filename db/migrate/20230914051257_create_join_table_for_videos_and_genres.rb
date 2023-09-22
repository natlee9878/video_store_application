class CreateJoinTableForVideosAndGenres < ActiveRecord::Migration[6.0] # your rails version might differ
  def change
    create_table :genres_videos, id: false do |t|
      t.belongs_to :video, index: true
      t.belongs_to :genre, index: true
    end
  end
end