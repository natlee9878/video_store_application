class AddColumnsToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :format_type, :integer
    add_column :rentals, :video_id, :integer
  end
end
