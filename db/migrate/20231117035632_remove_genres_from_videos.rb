class RemoveGenresFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :genres
    remove_column :rentals, :format_type
    remove_column :rentals, :video_id

  end
end