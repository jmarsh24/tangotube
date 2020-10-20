class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :genre  
      t.string :title  
      t.string :artist 
      t.timestamps null: false
    end
  end
end
