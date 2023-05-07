class AddDateFieldToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :new_date, :date
  end
end
