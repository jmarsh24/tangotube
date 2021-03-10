ActiveAdmin.register Video do
  permit_params :title, :description, :tags, :youtube_id, :leader_id, :follower_id, :channel_id, :song_id,
                :youtube_song, :youtube_artist, :performance_date, :performance_number, :performance_total,
                :videotype_id, :event_id, :hidden

  includes :song, :leader, :follower, :channel

  config.sort_order = "id_asc"
  config.per_page = [100, 500, 1000]

  scope :all
  scope :has_song
  scope :has_leader
  scope :has_follower
  scope :missing_leader
  scope :missing_follower
  # scope :has_youtube_song
  # scope :successful_acrcloud
  # scope :unsuccesful_acrcloud
  # scope :filter_by_hidden

  # filter :id_cont, label: "id"
  # filter :leader_name_cont, label: "Leader", collection: proc { Leader.order(:name) }
  # filter :follower_name_cont, label: "Follower", collection: proc { Follower.order(:name) }
  # filter :channel_title_cont, label: "Channel", collection: proc { Channel.order(:title) }
  # filter :youtube_id_cont, label: "Youtube ID "
  # filter :title_cont, label: "Title"
  # filter :description_cont, label: "Description"
  # filter :created_at, as: :date_range

  index do
    selectable_column
    id_column
    # column "Logo" do |video|
    #   image_tag video.channel.thumbnail_url, height: 30
    # end
    # column "channel" do |video|
    #   link_to(video.channel.title, "/admin/channels/#{video.channel.id}", target: :_blank, rel: :noopener) + " " +
    #     link_to("Youtube", "http://youtube.com/channel/#{video.channel.channel_id}", target: :_blank, rel: :noopener) + " " +
    #     link_to("Social Blade", "https://socialblade.com/youtube/channel/#{video.channel.channel_id}",
    #             target: :_blank, rel: :noopener) + " " +
    #     link_to("TangoTube", root_path(channel: video.channel.title), target: :_blank, rel: :noopener)
    # end
    # column "Thumbnail" do |video|
    #   link_to(image_tag("http://img.youtube.com/vi/#{video.youtube_id}/mqdefault.jpg", height: 100),
    #           "/watch?v=#{video.youtube_id}", target: :_blank, rel: :noopener)
    # end
    column :title
    column :description
    column :tags
    column "Youtube ID", :youtube_id
    column :leader
    column :follower
    column :song
    # column "Genre" do |video|
    #   video.song&.genre&.titleize
    # end
    # column "Artist" do |video|
    #   video.song&.artist&.titleize
    # end
    column :youtube_artist
    column :youtube_song
    column "ACR", :acr_response_code
    column :spotify_track_name
    column :spotify_artist_name
    column :hidden
    column :hd
    column :popularity
    actions
  end

  form do |f|
    inputs "details" do
      input :title
      input :description
      input :leader
      input :follower
      input :youtube_id
      input :channel_id
      input :song_id
      input :hidden
      input :popularity
    end
    f.actions
  end

  # batch_action :hide do |video|
  #   video.find(selection).each(&:hidden!)
  # end
end
