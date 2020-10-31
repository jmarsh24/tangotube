ActiveAdmin.register Video do
  permit_params :title, :youtube_id, :leader_id, :follower_id, :description, :channel, :channel_id, :duration, :upload_date, :view_count, :avg_rating, :tags, :song_id, :youtube_song, :youtube_artist, :performance_date, :performance_number, :performance_total, :videotype_id, :event_id

end
