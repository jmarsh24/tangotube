class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.timestamps
      t.string :title
      t.string :city
      t.string :country
      t.string :category
      t.date :start_date
      t.date :end_date
    end
  end
end
