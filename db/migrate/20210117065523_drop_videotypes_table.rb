class DropVideotypesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :videotypes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
