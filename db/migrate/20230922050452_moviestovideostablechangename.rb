class Moviestovideostablechangename < ActiveRecord::Migration[7.0]
  def change
    rename_table :actor_movies, :actor_videos
  end
end

