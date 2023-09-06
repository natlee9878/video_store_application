class AddDetailsToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :genre, :string
    add_column :videos, :avg_rating, :integer
  end
end
