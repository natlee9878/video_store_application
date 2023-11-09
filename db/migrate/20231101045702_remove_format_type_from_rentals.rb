class RemoveFormatTypeFromRentals < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :format_type, :integer
  end
end