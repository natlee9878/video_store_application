class SetDefaultRoleForUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, "regular"
    User.where(role: nil).update_all(role: "regular")
  end
end
