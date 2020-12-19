ActiveAdmin.register Video do
  permit_params :youtube_id, :leader_id, :follower_id, :channel_id, :song_id, :youtube_song, :youtube_artist,
                :performance_date, :performance_number, :performance_total, :videotype_id, :event_id
end
