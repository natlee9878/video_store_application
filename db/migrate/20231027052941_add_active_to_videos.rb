class AddActiveToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :active, :boolean
  end
end
