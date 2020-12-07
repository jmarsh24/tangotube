class AddColumnToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :length, 'time without time zone'
  end
end
