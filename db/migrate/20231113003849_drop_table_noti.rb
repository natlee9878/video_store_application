class DropTableNoti < ActiveRecord::Migration[7.0]
  def up
    drop_table :notification_requests
  end
end
