# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                             :bigint           not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  title                          :text
#  youtube_id                     :string
#  leader_id                      :bigint
#  follower_id                    :bigint
#  description                    :string
#  duration                       :integer
#  upload_date                    :datetime
#  view_count                     :integer
#  tags                           :string
#  song_id                        :bigint
#  youtube_song                   :string
#  youtube_artist                 :string
#  acrid                          :string
#  spotify_album_id               :string
#  spotify_album_name             :string
#  spotify_artist_id              :string
#  spotify_artist_id_2            :string
#  spotify_artist_name            :string
#  spotify_artist_name_2          :string
#  spotify_track_id               :string
#  spotify_track_name             :string
#  youtube_song_id                :string
#  isrc                           :string
#  acr_response_code              :integer
#  channel_id                     :bigint
#  scanned_song                   :boolean          default(FALSE)
#  hidden                         :boolean          default(FALSE)
#  hd                             :boolean          default(FALSE)
#  popularity                     :integer          default(0)
#  like_count                     :integer          default(0)
#  dislike_count                  :integer          default(0)
#  favorite_count                 :integer          default(0)
#  comment_count                  :integer          default(0)
#  event_id                       :bigint
#  scanned_youtube_music          :boolean          default(FALSE)
#  click_count                    :integer          default(0)
#  acr_cloud_artist_name          :string
#  acr_cloud_artist_name_1        :string
#  acr_cloud_album_name           :string
#  acr_cloud_track_name           :string
#  performance_date               :datetime
#  spotify_artist_id_1            :string
#  spotify_artist_name_1          :string
#  performance_number             :integer
#  performance_total_number       :integer
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#  featured                       :boolean          default(FALSE)
#
FactoryBot.define do
  factory :video do
    channel

    sequence(:youtube_id) { |n| "fancy_youtube_slug#{n}" }
    performance_date { "2017-10-26" }

    trait :display do
      duration { "100" }
      upload_date { "2017-10-26" }
    end

    factory :watched_video do
      leader
      follower
      after(:create) do |video|
        ahoy = Ahoy::Tracker.new
        ahoy.track("Video View", youtube_id: video.youtube_id)
      end
    end
  end
end
