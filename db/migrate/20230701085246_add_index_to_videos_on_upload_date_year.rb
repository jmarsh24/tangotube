class AddIndexToVideosOnUploadDateYear < ActiveRecord::Migration[7.1]
  def change
    add_index :videos, :upload_date_year
  end
end
