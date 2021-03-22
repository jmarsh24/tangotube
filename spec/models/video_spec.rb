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

  it { is_expected.to validate_presence_of(:youtube_id) }
  it { is_expected.to validate_uniqueness_of(:youtube_id) }

  it { is_expected.to belong_to(:leader).optional }
  it { is_expected.to belong_to(:follower).optional }
  it { is_expected.to belong_to(:song).optional }
  it { is_expected.to belong_to(:channel) }
  it { is_expected.to belong_to(:event).optional }

  it "click_count should == 1 " do
    video = create(:video, click_count: 0)
    video.clicked!
    expect(video.click_count).to eq(1)
  end

  describe ".display.any_song_attribute" do
    it "only song exists" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = create(:video, click_count: 0, song: song)

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end

    it "song doesn't exist" do
      video = create(:video)

      expect(video.display.any_song_attributes).to eq(nil)
    end

    it "only youtube song exists" do
      video = create(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr_cloud exists" do
      video = create(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only spotify exists" do
      video = create(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")

      expect(video.display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.external_song_attributes" do
    it "only spotify exists" do
      video = create(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")

      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only youtube exists" do
      video = create(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")
      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr cloud exists" do
      video = create(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")

      expect(video.display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "no song attributes exist" do
      video = create(:video)

      expect(video.display.external_song_attributes).to eq(nil)
    end
  end

  describe ".display.el_recodo_attributes" do
    it "missing song" do
      video = create(:video, song: nil)
      expect(video.display.el_recodo_attributes).to eq(nil)
    end

    it "has all attributes" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = create(:video, song: song)
      expect(video.display.el_recodo_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end
  end

  describe ".display.spotify_attributes" do
    it "has both track_name and artist_name" do
      video = create(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'AGOSTINO")
      expect(video.display.spotify_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing artist_name" do
      video = create(:video, spotify_track_name: "No Vendrá", spotify_artist_name: nil)
      expect(video.display.spotify_attributes).to eq(nil)
    end

    it "missing track_name" do
      video = create(:video, spotify_artist_name: "Angel D'AGOSTINO", spotify_track_name: nil)
      expect(video.display.spotify_attributes).to eq(nil)
    end
  end

  describe ".display.youtube_attributes" do
    it "has both youtube_song and youtube_artist" do
      video = create(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'AGOSTINO")
      expect(video.display.youtube_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing youtube_song" do
      video = create(:video, youtube_artist: "Angel D'AGOSTINO", youtube_song: nil)
      expect(video.display.youtube_attributes).to eq(nil)
    end

    it "missing artist_name" do
      video = create(:video, youtube_song: "Angel D'AGOSTINO", youtube_artist: nil)
      expect(video.display.youtube_attributes).to eq(nil)
    end
  end

  describe ".display.acr_cloud_attributes" do
    it "missing acr_cloud_track_name" do
      video = create(:video, acr_cloud_artist_name: "Angel D'AGOSTINO", acr_cloud_track_name: nil)
      expect(video.display.acr_cloud_attributes).to eq(nil)
    end

    it "missing acr_cloud_artist_name" do
      video = create(:video, acr_cloud_track_name: "Angel D'AGOSTINO", acr_cloud_artist_name: nil)
      expect(video.display.acr_cloud_attributes).to eq(nil)
    end

    it "has both acr_cloud_track_name and acr_cloud_artist_name" do
      video = create(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'AGOSTINO")
      expect(video.display.acr_cloud_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.dancer_names" do
    it "missing leader" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, leader: nil, follower: follower)
      expect(video.display.dancer_names).to eq(nil)
    end

    it "missing follower" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader, follower: nil)
      expect(video.display.dancer_names).to eq(nil)
    end

    it "has both leader and follower" do
      leader = create(:leader, name: "Carlitos Espinoza")
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, leader: leader, follower: follower)
      expect(video.display.dancer_names).to eq("Carlitos Espinoza & Noelia Hurtado")
    end
  end

  describe ".filter_by_event_id" do
    it "returns video with corresponding orchestra name" do
      song = create(:song, artist: "Juan d'Arienzo")
      video = create(:video, song: song)
      @result = described_class.filter_by_orchestra("Juan d'Arienzo")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_event_id" do
    it "returns video with corresponding event id" do
      song = create(:song, genre: "TANGO")
      video = create(:video, song: song)
      @result = described_class.filter_by_genre("Tango")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_leader" do
    it "returns video with corresponding orchestra event_id" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader)
      @result = described_class.filter_by_leader("Carlitos Espinoza")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_follower" do
    it "returns videos with matching follower name in video" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: follower)
      @result = described_class.filter_by_follower("Noelia Hurtado")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_channel" do
    it "returns videos with matching channel name in video" do
      channel = create(:channel, title: "030 Tango")
      video = create(:video, channel: channel)
      @result = described_class.filter_by_channel("030 Tango")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_event_id" do
    it "returns videos with matching event_id in video" do
      event = create(:event, title: "Embrace Berlin", id: 1)
      video = create(:video, event: event)
      @result = described_class.filter_by_event_id("1")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_song_id" do
    it "returns videos with song_id in video" do
      song = create(:song, id: 1)
      video = create(:video, song: song)
      @result = described_class.filter_by_song_id("1")
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_hd" do
    it "returns videos with hd: true" do
      video = create(:video, hd: true)
      @result = described_class.filter_by_hd(true)
      expect(@result).to include(video)
    end

    it "returns videos with hd: false" do
      video = create(:video, hd: false)
      @result = described_class.filter_by_hd(false)
      expect(@result).to include(video)
    end
  end

  describe "filter_by_hidden" do
    it "filter_by_hidden" do
      video = create(:video, hidden: true)
      @result = described_class.hidden
      expect(@result).to include(video)
    end
  end

  describe ".filter_by_not_hidden" do
    it "filter_by_not_hidden" do
      video = create(:video, hidden: false)
      @result = described_class.not_hidden
      expect(@result).to include(video)
    end
  end

  describe ".paginate" do
  end

  describe ".has_song" do
    it "returns by videos with a song" do
      song = create(:song)
      video = create(:video, song: song)
      @result = described_class.has_song
      expect(@result).to include(video)
    end
  end

  describe ".not_hidden" do
    it "returns by videos with a song" do
      video = create(:video, hidden: false)
      @result = described_class.not_hidden
      expect(@result).to include(video)
    end
  end

  describe ".has_leader" do
    it "returns by videos with a song" do
      leader = create(:leader)
      video = create(:video, leader: leader)
      @result = described_class.has_leader
      expect(@result).to include(video)
    end
  end

  describe ".has_follower" do
    it "returns by videos with a song" do
      follower = create(:follower)
      video = create(:video, follower: follower)
      @result = described_class.has_follower
      expect(@result).to include(video)
    end
  end

  describe ".has_youtube_song" do
    it "returns by videos with a song" do
      video = create(:video, youtube_song: "La Mentirosa", youtube_artist: "Osvaldo PUGLIESE")
      @result = described_class.has_youtube_song
      expect(@result).to include(video)
    end
  end

  describe ".missing_follower" do
    it "returns by videos with a song" do
      video = create(:video)
      @result = described_class.missing_follower
      expect(@result).to include(video)
    end
  end

  describe ".missing_leader" do
    it "returns by videos missing a leader" do
      video = create(:video)
      @result = described_class.missing_leader
      expect(@result).to include(video)
    end
  end

  describe ".missing_song" do
    it "returns by videos with a song" do
      video = create(:video)
      @result = described_class.missing_song
      expect(@result).to include(video)
    end
  end

  describe ".scanned_youtube_music" do
    it "returns by videos with a song" do
      video = create(:video, scanned_youtube_music: true)
      @result = described_class.scanned_youtube_music
      expect(@result).to include(video)
    end
  end

  describe ".not_scanned_youtube_music" do
    it "returns by videos with a song" do
      video = create(:video, scanned_youtube_music: false)
      @result = described_class.not_scanned_youtube_music
      expect(@result).to include(video)
    end
  end

  describe ".has_youtube_song" do
    it "returns by videos with youtube_song" do
      video = create(:video, youtube_song: "La Mentirosa")
      @result = described_class.has_youtube_song
      expect(@result).to include(video)
    end
  end

  describe ".successful_acrcloud" do
    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 0)
      @result = described_class.successful_acrcloud
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 1001)
      @result = described_class.successful_acrcloud
      expect(@result).not_to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: nil)
      @result = described_class.successful_acrcloud
      expect(@result).not_to include(video)
    end
  end

  describe ".not_successful_acrcloud" do
    it "returns by videos with a 1001 acr_response_code" do
      video = create(:video, acr_response_code: 1001)
      @result = described_class.not_successful_acrcloud
      expect(@result).to include(video)
    end

    it "does not return videos with nil acr_response_code" do
      video = create(:video, acr_response_code: nil)
      @result = described_class.not_successful_acrcloud
      expect(@result).not_to include(video)
    end

    it "does not return videos with 0 acr_response_code" do
      video = create(:video, acr_response_code: 0)
      @result = described_class.not_successful_acrcloud
      expect(@result).not_to include(video)
    end
  end

  describe ".scanned_acrcloud" do
    it "returns by videos with a song" do
      video = create(:video, acr_response_code: nil)
      @result = described_class.scanned_acrcloud
      expect(@result).not_to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 0)
      @result = described_class.scanned_acrcloud
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 1001)
      @result = described_class.scanned_acrcloud
      expect(@result).to include(video)
    end
  end

  describe ".not_scanned_acrcloud" do
    it "returns by videos with a song" do
      video = create(:video, acr_response_code: nil)
      @result = described_class.not_scanned_acrcloud
      expect(@result).not_to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 0)
      @result = described_class.not_scanned_acrcloud
      expect(@result).not_to include(video)
    end

    it "returns by videos with a song" do
      video = create(:video, acr_response_code: 1001)
      @result = described_class.not_scanned_acrcloud
      expect(@result).not_to include(video)
    end
  end

  describe ".with_song_title" do
    it "returns by videos with a spotify_track_song" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, spotify_track_name: "No Vendra")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end

    it "returns by videos with a youtube_song" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, youtube_song: "No Vendra")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end

    it "returns by videos with a title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, title: "This is a video with No Vendra by Angel D'Agostino")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end

    it "returns by videos with a description" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, description: "This is a video with No Vendra by Angel D'Agostino")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end

    it "returns by videos with a song title in tags" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, tags: "This is a video with No Vendra by Angel D'Agostino")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end

    it "returns by videos with a song title in tags" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, acr_cloud_track_name: "This is a video with No Vendra by Angel D'Agostino")
      @result = described_class.with_song_title(song.title)
      expect(@result).to include(video)
    end
  end

  describe ".with_song_artist_keyword" do
    it "returns by videos with a song in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_artist_name: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a spotify_artist_name_2 in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_artist_name_2: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a youtube_artist in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, youtube_artist: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a description in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, description: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a title in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, title: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a tags in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, tags: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with a spotify_album_name in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_album_name: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with an acr_cloud_artist_name in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, acr_cloud_artist_name: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end

    it "returns by videos with an acr_cloud_artist_name_1 in video" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, acr_cloud_artist_name_1: "Angel D'Agostino")
      @result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(@result).to include(video)
    end
  end

  describe ".with_dancer_name_in_title" do
    it "returns by videos with a song" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, title: "Title with Carlitos Espinoza")
      @result = described_class.with_dancer_name_in_title(leader.full_name)
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      leader = create(:leader, first_name: "Carlitos", last_name: "Espinoza")
      video = create(:video, title: "Title with Carlitos Espinoza")
      @result = described_class.with_dancer_name_in_title(leader.full_name)
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, title: "Title with Noelia Hurtado")
      @result = described_class.with_dancer_name_in_title(follower.full_name)
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      follower = create(:follower, first_name: "Noelia", last_name: "Hurtado")
      video = create(:video, title: "Title with Noelia Hurtado")
      @result = described_class.with_dancer_name_in_title(follower.full_name)
      expect(@result).to include(video)
    end
  end

  describe ".title_match_missing_leader" do
    it "returns by videos with a song" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: nil, title: "Title with Carlitos Espinoza")
      @result = described_class.title_match_missing_leader(leader.full_name)
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader, title: "Title with Carlitos Espinoza")
      @result = described_class.title_match_missing_leader(leader.full_name)
      expect(@result).not_to include(video)
    end
  end

  describe ".title_match_missing_follower" do
    it "returns by videos with a song" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: nil, title: "Title with Noelia Hurtado")
      @result = described_class.title_match_missing_follower(follower.full_name)
      expect(@result).to include(video)
    end

    it "returns by videos with a song" do
      follower = create(:follower, name: "Carlitos Espinoza")
      video = create(:video, follower: follower, title: "Title with Carlitos Espinoza")
      @result = described_class.title_match_missing_follower(follower.full_name)
      expect(@result).not_to include(video)
    end
  end

  describe ".filter_by_query" do
    it "finds video with title" do
      video = create(:video, title: "Title with carlitos espinoza")
      VideosSearch.refresh
      @result = described_class.filter_by_query("Carlitos Espinoza")
      expect(@result).to include(video)
    end

    it "finds video with title" do
      video = create(:video, description: "description with carlitos espinoza")
      VideosSearch.refresh
      @result = described_class.filter_by_query("Carlitos Espinoza")
      expect(@result).to include(video)
    end

    it "finds video with leader" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader)
      VideosSearch.refresh
      @result = described_class.filter_by_query("Carlitos Espinoza")
      expect(@result).to include(video)
    end

    it "finds video with leader" do
      leader = create(:leader, nickname: "Carlitos")
      video = create(:video, leader: leader)
      VideosSearch.refresh
      @result = described_class.filter_by_query("Carlitos")
      expect(@result).to include(video)
    end

    it "finds video with follower" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: follower)
      VideosSearch.refresh
      @result = described_class.filter_by_query("Noelia Hurtado")
      expect(@result).to include(video)
    end

    it "finds video with follower" do
      follower = create(:follower, nickname: "Noelia")
      video = create(:video, follower: follower)
      VideosSearch.refresh
      @result = described_class.filter_by_query("Noelia")
      expect(@result).to include(video)
    end

    it "finds video with youtube_id" do
      video = create(:video, youtube_id: "s6iptZdCcG0")
      VideosSearch.refresh
      @result = described_class.filter_by_query("s6iptZdCcG0")
      expect(@result).to include(video)
    end

    it "finds video with youtube_artist" do
      video = create(:video, youtube_artist: "Angel D'Agostino")
      VideosSearch.refresh
      @result = described_class.filter_by_query("Agostino")
      expect(@result).to include(video)
    end

    it "finds video with youtube_song" do
      video = create(:video, youtube_song: "No Vendrá")
      VideosSearch.refresh
      @result = described_class.filter_by_query("no vendrá")
      expect(@result).to include(video)
    end

    it "finds video with spotify_track_name" do
      video = create(:video, spotify_track_name: "No Vendrá")
      VideosSearch.refresh
      @result = described_class.filter_by_query("no vendrá")
      expect(@result).to include(video)
    end

    it "finds video with spotify_artist_name" do
      video = create(:video, spotify_artist_name: "Angel D'Agostino")
      VideosSearch.refresh
      @result = described_class.filter_by_query("agostino")
      expect(@result).to include(video)
    end

    it "finds video with channel title" do
      channel = create(:channel, title: "030 Tango")
      video = create(:video, channel: channel)
      VideosSearch.refresh
      @result = described_class.filter_by_query("030 tango")
      expect(@result).to include(video)
    end

    it "finds video with channel_id" do
      channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
      video = create(:video, channel: channel)
      VideosSearch.refresh
      @result = described_class.filter_by_query("UCtdgMR0bmogczrZNpPaO66Q")
      expect(@result).to include(video)
    end

    it "finds video with song genre" do
      song = create(:song, genre: "Tango")
      video = create(:video, song: song)
      VideosSearch.refresh
      @result = described_class.filter_by_query("tango")
      expect(@result).to include(video)
    end

    it "finds video with song title" do
      song = create(:song, title: "La Mentirosa")
      video = create(:video, song: song)
      VideosSearch.refresh
      @result = described_class.filter_by_query("mentirosa")
      expect(@result).to include(video)
    end

    it "finds video with song artist" do
      song = create(:song, artist: "Angel D'Agostino")
      video = create(:video, song: song)
      VideosSearch.refresh
      @result = described_class.filter_by_query("d'agostino")
      expect(@result).to include(video)
    end
  end
end
