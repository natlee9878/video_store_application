class AddFormatTypeToRentalsVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals_videos, :format_type, :integer
  end
end