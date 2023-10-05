class AddOnHandToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :on_hand, :integer
  end
end
