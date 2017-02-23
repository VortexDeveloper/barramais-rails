class DropAreasTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :areas
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
