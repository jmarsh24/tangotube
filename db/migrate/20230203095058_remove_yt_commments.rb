class RemoveYtCommments < ActiveRecord::Migration[7.0]
  def change
    drop_table :yt_comments
  end
end
