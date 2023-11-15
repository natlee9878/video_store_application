class RenameRentalsVideosIdToRentalsVideoIdInNotifications < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :rentals_videos_id, :rentals_video_id
  end
end