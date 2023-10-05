class ChangeFormatTypeInStocks < ActiveRecord::Migration[7.0]
  def up
    change_column :stocks, :format_type, :integer, using: 'format_type::integer'
  end

  def down
    change_column :stocks, :format_type, :string
  end
end