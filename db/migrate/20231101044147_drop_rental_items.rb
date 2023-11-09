class DropRentalItems < ActiveRecord::Migration[6.0] # Use the version of your current Rails
  def change
    drop_table :rental_items do |t|
      # If you need to preserve the data or schema information, you can do it here.
      # For example, you can use `t.string :name` to keep the schema of the `name` column.
    end
  end
end