class ChangeRemoveSFromActorsVideosTableId < ActiveRecord::Migration[7.0]
  def change
    rename_column :actor_videos, :actors_id, :actor_id
    rename_column :actor_videos, :videos_id, :video_id
  end
end