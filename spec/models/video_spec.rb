# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  title                    :text
#  youtube_id               :string
#  description              :string
#  duration                 :integer
#  upload_date              :date
#  view_count               :integer
#  tags                     :string
#  song_id                  :bigint
#  youtube_song             :string
#  youtube_artist           :string
#  acrid                    :string
#  spotify_album_id         :string
#  spotify_album_name       :string
#  spotify_artist_id        :string
#  spotify_artist_id_2      :string
#  spotify_artist_name      :string
#  spotify_artist_name_2    :string
#  spotify_track_id         :string
#  spotify_track_name       :string
#  youtube_song_id          :string
#  isrc                     :string
#  acr_response_code        :integer
#  channel_id               :bigint
#  scanned_song             :boolean          default(FALSE)
#  hidden                   :boolean          default(FALSE)
#  hd                       :boolean          default(FALSE)
#  popularity               :integer          default(0)
#  like_count               :integer          default(0)
#  dislike_count            :integer          default(0)
#  favorite_count           :integer          default(0)
#  comment_count            :integer          default(0)
#  event_id                 :bigint
#  scanned_youtube_music    :boolean          default(FALSE)
#  click_count              :integer          default(0)
#  acr_cloud_artist_name    :string
#  acr_cloud_artist_name_1  :string
#  acr_cloud_album_name     :string
#  acr_cloud_track_name     :string
#  performance_date         :datetime
#  spotify_artist_id_1      :string
#  spotify_artist_name_1    :string
#  performance_number       :integer
#  performance_total_number :integer
#  featured                 :boolean          default(FALSE)
#  index                    :text
#
require "rails_helper"

RSpec.describe Video do
  fixtures :all

  let(:video_1) { videos(:video_1) }
  let(:song_1) { songs(:song_1) }
  let(:leader_1) { leaders(:leader_1) }
  let(:follower_1) { followers(:follower_1) }
  let(:channel_1) { channels(:channel_1) }
  let(:event_1) { events(:event_1) }
end
