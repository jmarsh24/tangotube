# == Schema Information
#
# Table name: videos
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  title                   :text
#  youtube_id              :string
#  leader_id               :bigint
#  follower_id             :bigint
#  description             :string
#  duration                :integer
#  upload_date             :date
#  view_count              :integer
#  tags                    :string
#  song_id                 :bigint
#  youtube_song            :string
#  youtube_artist          :string
#  acrid                   :string
#  spotify_album_id        :string
#  spotify_album_name      :string
#  spotify_artist_id       :string
#  spotify_artist_id_2     :string
#  spotify_artist_name     :string
#  spotify_artist_name_2   :string
#  spotify_track_id        :string
#  spotify_track_name      :string
#  youtube_song_id         :string
#  isrc                    :string
#  acr_response_code       :integer
#  channel_id              :bigint
#  scanned_song            :boolean          default(FALSE)
#  hidden                  :boolean          default(FALSE)
#  hd                      :boolean          default(FALSE)
#  popularity              :integer          default(0)
#  like_count              :integer          default(0)
#  dislike_count           :integer          default(0)
#  favorite_count          :integer          default(0)
#  comment_count           :integer          default(0)
#  event_id                :bigint
#  scanned_youtube_music   :boolean          default(FALSE)
#  click_count             :integer          default(0)
#  spotify_artist_id_1     :string
#  spotify_artist_name_1   :string
#  acr_cloud_artist_name   :string
#  acr_cloud_artist_name_1 :string
#  acr_cloud_album_name    :string
#  acr_cloud_track_name    :string
#

or# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :text
#  youtube_id         :string
#  leader_id          :bigint
#  follower_id        :bigint
#  description        :string
#  channel            :string
#  channel_id         :string
#  duration           :integer
#  upload_date        :date
#  view_count         :integer
#  avg_rating         :integer
#  tags               :string
#  song_id            :bigint
#  youtube_song       :string
#  youtube_artist     :string
#  performance_date   :datetime
#  performance_number :integer
#  performance_total  :integer
#  videotype_id       :bigint
#  event_id           :bigint
#

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
