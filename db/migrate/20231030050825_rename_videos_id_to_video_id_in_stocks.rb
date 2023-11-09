class RenameVideosIdToVideoIdInStocks < ActiveRecord::Migration[6.0] # or the version of ActiveRecord you're using
  def change
    rename_column :stocks, :videos_id, :video_id
  end
end
