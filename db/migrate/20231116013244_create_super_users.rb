class CreateSuperUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :super_users do |t|

      t.timestamps
    end
  end
end
