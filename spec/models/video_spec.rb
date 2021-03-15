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
require "rails_helper"
require_relative "../support/devise"

RSpec.describe Video, type: :model do
  let(:video) { build(:video) }
  let(:channel) { build(:channel) }

  it { is_expected.to validate_presence_of(:youtube_id) }
  it { is_expected.to validate_uniqueness_of(:youtube_id) }

  it { is_expected.to belong_to(:leader).optional }
  it { is_expected.to belong_to(:follower).optional }
  it { is_expected.to belong_to(:song).optional }
  it { is_expected.to belong_to(:channel) }
  it { is_expected.to belong_to(:event).optional }

  it "click_count should == 1 " do
    channel = create(:channel)
    video = create(:video, click_count: 0, channel: channel)
    video.clicked!
    expect(video.click_count).to eq(1)
  end

  it "displays full title of song attribute if it exists" do
    channel = create(:channel)
    song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
    video = create(:video, click_count: 0, channel: channel, song: song, youtube_song: "No Vendrá", youtube_artist: "")

    expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'agostino - Tango")
  end
end
