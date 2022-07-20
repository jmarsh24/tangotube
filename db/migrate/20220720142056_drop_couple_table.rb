class DropCoupleTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :couples
  end
end
