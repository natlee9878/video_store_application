class ModifyUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :name, :first_name

    add_column :users, :last_name, :string
    add_column :users, :address_line, :string
    add_column :users, :suburb, :string
    add_column :users, :state, :integer, default: 0, null: false
    add_column :users, :postcode, :integer, limit: 4

    # Since you want state as an ENUM,
    # add an enum mapping in the user model after running the migration
  end
end
