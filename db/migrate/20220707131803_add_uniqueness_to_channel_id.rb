class AddUniquenessToChannelId < ActiveRecord::Migration[7.0]
  def change
    add_index :channels, :channel_id, unique: true
  end
end
