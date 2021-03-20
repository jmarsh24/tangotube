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

  describe ".display.any_song_attribute" do
    it "only song exists" do
      channel = create(:channel)
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = create(:video, click_count: 0, channel: channel, song: song)

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end

    it "song doesn't exist" do
      channel = create(:channel)
      video = create(:video, channel: channel)

      expect(video.display.any_song_attributes).to eq(nil)
    end

    it "only youtube song exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr_cloud exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only spotify exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.external_song_attributes" do
    it "only spotify exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")

      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only youtube exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")
      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr cloud exists" do
      channel = create(:channel)
      video = create(:video, channel: channel, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")

      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "no song attributes exist" do
      channel = create(:channel)
      video = create(:video, channel: channel)

      expect(video.display.external_song_attributes).to eq(nil)
    end
  end

  describe ".display.el_recodo_attributes" do
    it "missing song" do
      channel = create(:channel)
      video = create(:video, channel: channel, song: nil)
      expect(video.display.el_recodo_attributes).to eq(nil)
    end

    it "has all attributes" do
      channel = create(:channel)
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = create(:video, channel: channel, song: song)
      expect(video.display.el_recodo_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end
  end

  describe ".display.spotify_attributes" do
    it "has both track_name and artist_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'AGOSTINO")
      expect(video.display.spotify_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing artist_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, spotify_track_name: "No Vendrá", spotify_artist_name: nil)
      expect(video.display.spotify_attributes).to eq(nil)
    end

    it "missing track_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, spotify_artist_name: "Angel D'AGOSTINO", spotify_track_name: nil)
      expect(video.display.spotify_attributes).to eq(nil)
    end
  end

  describe ".display.youtube_attributes" do
    it "has both youtube_song and youtube_artist" do
      channel = create(:channel)
      video = create(:video, channel: channel, youtube_song: "No Vendrá", youtube_artist: "Angel D'AGOSTINO")
      expect(video.display.youtube_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing youtube_song" do
      channel = create(:channel)
      video = create(:video, channel: channel, youtube_artist: "Angel D'AGOSTINO", youtube_song: nil)
      expect(video.display.youtube_attributes).to eq(nil)
    end

    it "missing artist_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, youtube_song: "Angel D'AGOSTINO", youtube_artist: nil)
      expect(video.display.youtube_attributes).to eq(nil)
    end
  end

  describe ".display.acr_cloud_attributes" do
    it "missing acr_cloud_track_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, acr_cloud_artist_name: "Angel D'AGOSTINO", acr_cloud_track_name: nil)
      expect(video.display.acr_cloud_attributes).to eq(nil)
    end

    it "missing acr_cloud_artist_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, acr_cloud_track_name: "Angel D'AGOSTINO", acr_cloud_artist_name: nil)
      expect(video.display.acr_cloud_attributes).to eq(nil)
    end

    it "has both acr_cloud_track_name and acr_cloud_artist_name" do
      channel = create(:channel)
      video = create(:video, channel: channel, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'AGOSTINO")
      expect(video.display.acr_cloud_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.dancer_names" do
    it "missing leader" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, channel: channel, leader: nil, follower: follower)
      expect(video.display.dancer_names).to eq(nil)
    end

    it "missing follower" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, channel: channel, leader: leader, follower: nil)
      expect(video.display.dancer_names).to eq(nil)
    end

    it "has both leader and follower" do
      leader = create(:leader, name: "Carlitos Espinoza")
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, channel: channel, leader: leader, follower: follower)
      expect(video.display.dancer_names).to eq("Carlitos Espinoza & Noelia Hurtado")
    end
  end

  describe "scopes" do
  end
end
