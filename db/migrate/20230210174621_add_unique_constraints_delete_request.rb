class AddUniqueConstraintsDeleteRequest < ActiveRecord::Migration[7.0]
  def change
    add_index :deletion_requests, :uid, unique: true
  end
end
