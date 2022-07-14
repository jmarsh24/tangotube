class CreateDancers < ActiveRecord::Migration[7.0]
  def change
    create_table :dancers do |t|
      t.string :name, null: false
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :nick_name
      t.references :user, foreign_key: true
      t.text :bio
      t.string :slug
      t.boolean :reviewed, null: false, default: false
      t.timestamps
    end
  end
end
