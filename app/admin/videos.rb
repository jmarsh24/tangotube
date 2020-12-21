ActiveAdmin.register Video do
  permit_params :title, :description, :tags, :youtube_id, :leader_id, :follower_id, :channel_id, :song_id,
                :youtube_song, :youtube_artist, :performance_date, :performance_number, :performance_total,
                :videotype_id, :event_id

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :tags
    column :youtube_id
    column :leader
    column :follower
    column :channel
    column :songs.title
    column :songs.artist
    column :songs.genre
    actions
  end
end
