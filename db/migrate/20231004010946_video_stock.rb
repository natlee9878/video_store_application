class VideoStock < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.references :videos, null: false, foreign_key: true
      t.string :format_type
      t.integer :number_owned

      t.timestamps
    end
  end
end