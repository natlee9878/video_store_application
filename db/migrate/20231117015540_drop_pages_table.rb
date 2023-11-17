class DropPagesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :pages
  end

  def down
    # Optionally, re-create the table in the down method for rollback
  end
end