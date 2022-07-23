class ChangeVideoUploadDateToDateTime < ActiveRecord::Migration[7.0]
  def change
    change_column :videos, :upload_date, :datetime
  end
  CallUpdateAllVideosJob.perform_async
end
