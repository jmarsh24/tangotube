class CreateOrchestras < ActiveRecord::Migration[7.0]
  def change
    create_table :orchestras do |t|
      t.string :name, null: false
      t.text :bio
      t.string :slug, null: false

      t.timestamps
    end
    add_reference :songs, :orchestra
    add_index :orchestras, :name, unique: true 
  end
end
