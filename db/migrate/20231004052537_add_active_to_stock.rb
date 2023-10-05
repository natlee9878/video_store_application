class AddActiveToStock < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :active, :boolean
  end
end
