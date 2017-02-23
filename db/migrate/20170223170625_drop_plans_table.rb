class DropPlansTable < ActiveRecord::Migration[5.0]
  def up
   drop_table :plans
  end

  def down
   raise ActiveRecord::IrreversibleMigration
  end
end
