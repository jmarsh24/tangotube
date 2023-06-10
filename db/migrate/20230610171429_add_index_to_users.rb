class AddIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, [:uid, :provider], unique: true
  end
end
