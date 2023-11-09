class CreateNotificationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_requests do |t|
      t.references :rentals_videos, null: false, foreign_key: true
      t.string :status, default: 'active' # status can be 'active' or 'inactive'

      t.timestamps
    end
  end
end
