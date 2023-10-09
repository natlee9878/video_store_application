class AddActiveToGenre < ActiveRecord::Migration[7.0]
  def change
    add_column :genres, :active, :boolean, default: true
  end
end
