class SetDefaultActiveInStocks < ActiveRecord::Migration[6.0]
  def change
    change_column :stocks, :active, :string, default: 'yes'
  end
end