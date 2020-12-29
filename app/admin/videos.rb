ActiveAdmin.register Video do

  permit_params :title, :description, :tags, :youtube_id, :leader_id, :follower_id, :channel_id, :song_id,
                :youtube_song, :youtube_artist, :performance_date, :performance_number, :performance_total,
                :videotype_id, :event_id

  config.sort_order = 'id_asc'
  config.per_page = [10, 50, 100]

  scope :all
  scope :has_song
  scope :has_leader
  scope :has_follower
  scope :has_youtube_match
  scope :has_acr_match

  filter :id_cont, label: 'id'
  filter :leader_name_cont,   label: 'Leader',    collection: proc { Leader.order(:name) }
  filter :follower_name_cont, label: 'Follower',  collection: proc { Follower.order(:name) }
  filter :channel_title_cont,  label: 'Channel',   collection: proc { Channel.order(:title) }
  filter :song_genre, as: :select, collections: proc {Songs.genres}
  filter :youtube_id_cont, label: 'Youtube ID '
  filter :title_cont, label: 'Title'
  filter :description_cont, label: 'Description'
  filter :created_at, as: :date_range

  index do
    selectable_column
    id_column
    # column "Logo" do |video|
    #   image_tag video.channel.thumbnail_url, height: 30
    # end
    column :channel
    column "Thumbnail" do |video|
      image_tag "http://img.youtube.com/vi/#{video.youtube_id}/mqdefault.jpg", height: 100
    end
    column :title
    column :description
    column :tags
    column "Yt Id", :youtube_id
    column :leader
    column :follower
    column :song
    column "Genre" do |video|
      video.song.genre.titleize if !video.song.nil?
    end
    column "Artist" do |video|
      video.song.artist.titleize if !video.song.nil?
    end
    column :youtube_artist
    column :youtube_song
    column "ACR", :acr_response_code
    column :spotify_track_name
    column :spotify_artist_name
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
