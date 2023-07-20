class RemoveImportedAtFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :imported_at, :datetime
  end
end
