class CreateRentalsVideos < ActiveRecord::Migration[7.0] # Make sure to use your Rails version
  def change
    create_table :rentals_videos do |t|
      t.integer :order_number, null: false
      t.integer :video_id, null: false

      t.timestamps
    end
  end
end