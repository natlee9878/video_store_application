class AddStatusToNotifications < ActiveRecord::Migration[6.0]  # Adjust the version as necessary
  def change
    add_column :notifications, :status, :boolean
  end
end