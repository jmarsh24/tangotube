class AddPatreonIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :patreon_id, :string
    add_index :users, :patreon_id
  end
end
