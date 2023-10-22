class AddUniqueIndexToVideoSearches < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :video_searches, :video_id, unique: true, algorithm: :concurrently
  end
end
