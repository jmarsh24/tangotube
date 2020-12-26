ActiveAdmin.register Video do
  includes :leader, :follower, :song, :channel

  permit_params :title, :description, :tags, :youtube_id, :leader_id, :follower_id, :channel_id, :song_id,
                :youtube_song, :youtube_artist, :performance_date, :performance_number, :performance_total,
                :videotype_id, :event_id,
                songs_attributes: [:id, :genre, :title, :artist]

  config.sort_order = 'id_asc'

  scope :all
  scope :has_song
  scope :has_leader
  scope :has_follower
  scope :has_youtube_match
  scope :has_acr_match

  index do
    selectable_column
    id_column
    column "Thumbnail" do |video|
      image_tag "http://img.youtube.com/vi/#{video.youtube_id}/mqdefault.jpg", height: 100
    end
    column :title
    column :description
    column :tags
    column :youtube_id
    column :leader
    column :follower
    column :channel
    column :"song.genre"
    actions
  end

  form do |f|
    inputs "details" do
      input :title
      input :description
      input :leader
      input :follower
      input :youtube_id
      input :channel
      input :song
    end
  end
end
