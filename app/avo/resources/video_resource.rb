# frozen_string_literal: true

class VideoResource < Avo::BaseResource
  self.title = :title
  self.includes = [Video.search_includes]
  self.search_query = -> do
    scope.ransack(title_eq: params[:q], m: "or").result(distinct: false)
  end

  grid do
    title :title, as: :text, link_to_resource: true
    body :description, as: :textarea
    cover :thumbnail_url, as: :external_image, link_to_resource: true
  end

  field :youtube_id, as: :text, link_to_resource: true
  field :thumbnail_url, as: :external_image
  field :title, as: :text
  field :description, as: :text, hide_on: [:index]
  field :hidden, as: :boolean
  field :featured, as: :boolean
  field :channel, as: :belongs_to, required: true, searchable: true
  # field :leader_id, as: :number
  # field :follower_id, as: :number
  # field :description, as: :textarea
  # field :duration, as: :number
  # field :upload_date, as: :datetime
  # field :view_count, as: :number
  field :tags, as: :text, hide_on: :index
  # field :song_id, as: :number
  # field :youtube_song, as: :text
  # field :youtube_artist, as: :text
  # field :acr_id, as: :text
  # field :spotify_album_id, as: :text
  # field :spotify_album_name, as: :text
  # field :spotify_artist_id, as: :text
  # field :spotify_artist_id_2, as: :text
  # field :spotify_artist_name, as: :text
  # field :spotify_artist_name_2, as: :text
  # field :spotify_track_id, as: :text
  # field :spotify_track_name, as: :text
  # field :youtube_song_id, as: :text
  # field :isrc, as: :text
  # field :acr_response_code, as: :number
  # field :channel_id, as: :number
  # field :scanned_song, as: :boolean
  # field :hidden, as: :boolean
  # field :hd, as: :boolean
  # field :popularity, as: :number
  # field :like_count, as: :number
  # field :dislike_count, as: :number
  # field :favorite_count, as: :number
  # field :comment_count, as: :number
  # field :event_id, as: :number
  # field :scanned_youtube_music, as: :boolean
  # field :click_count, as: :number
  # field :acr_cloud_artist_name, as: :text
  # field :acr_cloud_artist_name_1, as: :text
  # field :acr_cloud_album_name, as: :text
  # field :acr_cloud_track_name, as: :text
  # field :performance_date, as: :datetime
  # field :spotify_artist_id_1, as: :text
  # field :spotify_artist_name_1, as: :text
  # field :performance_number, as: :number
  # field :performance_total_number, as: :number
  # field :cached_scoped_like_votes_total, as: :number
  # field :cached_scoped_like_votes_score, as: :number
  # field :cached_scoped_like_votes_up, as: :number
  # field :cached_scoped_like_votes_down, as: :number
  # field :cached_weighted_like_score, as: :number
  # field :cached_weighted_like_total, as: :number
  # field :cached_weighted_like_average, as: :number
  # field :featured, as: :boolean
  # field :votes_for, as: :has_many
  # field :song, as: :belongs_to
  # field :channel, as: :belongs_to
  # field :event, as: :belongs_to
  # field :comments, as: :has_many
  # field :clips, as: :has_many
  # field :dancer_videos, as: :has_many
  # field :dancers, as: :has_many, through: :dancer_videos
  # field :follower_roles, as: :has_many
  # field :leader_roles, as: :has_many
  # field :leaders, as: :has_many, through: :leader_roles
  # field :followers, as: :has_many, through: :follower_roles
  # field :couple_videos, as: :has_many
  # field :couples, as: :has_many, through: :couple_videos
  # field :orchestra, as: :has_many, through: :song
  # field :performance_video, as: :has_one
  # field :performance, as: :has_many, through: :performance_video
  # add fields here
end
