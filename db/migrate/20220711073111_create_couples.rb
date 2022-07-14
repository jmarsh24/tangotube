class CreateCouples < ActiveRecord::Migration[7.0]
  def change
    create_table :couples do |t|
      t.bigint :dancer_a_id
      t.bigint :dancer_b_id
      t.timestamps
    end
    add_index :couples, %i[dancer_a_id dancer_b_id], unique: true
  end
end
