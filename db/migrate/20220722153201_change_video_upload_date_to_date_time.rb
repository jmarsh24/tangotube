class ChangeVideoUploadDateToDateTime < ActiveRecord::Migration[7.0]
  def change
    change_column :videos, :upload_date, :datetime
  end
  Video.all.find_each do |video|
    UpdateAllUploadDatesJob.perform_async(video.youtube_id)
  end
end
