class AddUserAndRentalToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :user_id, :integer
    add_column :notifications, :rental_id, :integer
  end
end
