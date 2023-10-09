class AddActiveToActors < ActiveRecord::Migration[7.0]
  def change
    add_column :actors, :active, :boolean, default: true
  end
end
