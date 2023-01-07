class AddIndexToEvents < ActiveRecord::Migration[7.0]
  def change
    remove_index :events, :title
    add_index :events, :title, unique: true
    change_column_null :events, :title, false
    change_column_null :events, :city, false
    change_column_null :events, :country, false
  end
end
