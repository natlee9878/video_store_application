class AddRentalsVideosToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :rentals_videos, foreign_key: true
    change_column_default :notifications, :status, from: nil, to: false
  end
end