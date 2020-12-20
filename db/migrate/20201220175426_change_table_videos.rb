class ChangeTableVideos < ActiveRecord::Migration[6.0]
  def change
    remove_column :videos, :channel, :string
    remove_column :videos, :channel_id, :string
    add_reference :videos, :channel
  end
end
