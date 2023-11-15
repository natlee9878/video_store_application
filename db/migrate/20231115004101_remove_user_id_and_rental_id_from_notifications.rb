class RemoveUserIdAndRentalIdFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :user_id, :integer
    remove_column :notifications, :rental_id, :integer
  end
end
