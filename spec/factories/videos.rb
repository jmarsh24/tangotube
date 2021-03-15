# == Schema Information
#
# Table name: videos
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  title                 :text
#  youtube_id            :string
#  leader_id             :bigint
#  follower_id           :bigint
#  description           :string
#  duration              :integer
#  upload_date           :date
#  view_count            :integer
#  tags                  :string
#  song_id               :bigint
#  youtube_song          :string
#  youtube_artist        :string
#  acrid                 :string
#  spotify_album_id      :string
#  spotify_album_name    :string
#  spotify_artist_id     :string
#  spotify_artist_id_2   :string
#  spotify_artist_name   :string
#  spotify_artist_name_2 :string
#  spotify_track_id      :string
#  spotify_track_name    :string
#  youtube_song_id       :string
#  isrc                  :string
#  acr_response_code     :integer
#  channel_id            :bigint
#  scanned_song          :boolean          default(FALSE)
#  hidden                :boolean          default(FALSE)
#  hd                    :boolean          default(FALSE)
#  popularity            :integer          default(0)
#  like_count            :integer          default(0)
#  dislike_count         :integer          default(0)
#  favorite_count        :integer          default(0)
#  comment_count         :integer          default(0)
#  event_id              :bigint
#  scanned_youtube_music :boolean          default(FALSE)
#  click_count           :integer          default(0)
#
FactoryBot.define do
  factory :video do
    title { "Example Title" }
    description { "Example Description" }
    youtube_id { "Example Youtube ID" }
    channel_id { 1 }
    click_count { 0 }
  end

  factory :random_video do
    title { "Example Title" }
    description { "Example Description" }
    youtube_id { "Example Youtube ID" }
    id
    created_at
    updated_at
    title
    youtube_id
    leader_id
    follower_id
    description
    duration
    upload_date
    view_count { Faker::Number.between(from: 1, to: 10_000_000) }
    tags
    song_id
    youtube_song
    youtube_artist
    acrid
    spotify_album_id
    spotify_album_name
    spotify_artist_id
    spotify_artist_id_2
    spotify_artist_name
    spotify_artist_name_2
    spotify_track_id
    spotify_track_name
    youtube_song_id
    isrc
    acr_response_code
    channel_id
    scanned_song
    hidden
    hd
    popularity
    like_count
    dislike_count
    favorite_count
    comment_count
    scanned_youtube_music
    click_count
  end
end
