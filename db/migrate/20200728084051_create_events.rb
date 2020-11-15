class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false, unique: true
      t.string :city
      t.string :country
      t.date :date
      t.timestamps
    end
  end
end
