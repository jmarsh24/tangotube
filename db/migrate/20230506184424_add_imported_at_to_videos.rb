class AddImportedAtToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :imported_at, :datetime
  end
end
