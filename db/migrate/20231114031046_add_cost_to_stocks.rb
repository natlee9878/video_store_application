class AddCostToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :cost, :decimal
  end
end
