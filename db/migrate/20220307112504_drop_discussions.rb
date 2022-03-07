class DropDiscussions < ActiveRecord::Migration[7.0]
  def change
    drop_table :discussions
  end
end
