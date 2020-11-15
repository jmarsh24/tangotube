class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end
end
