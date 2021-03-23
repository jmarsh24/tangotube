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

RSpec.describe Video, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:youtube_id) }
    it { is_expected.to validate_uniqueness_of(:youtube_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:leader).optional.counter_cache(true) }
    it { is_expected.to belong_to(:follower).optional.counter_cache(true) }
    it { is_expected.to belong_to(:song).optional.counter_cache(true) }
    it { is_expected.to belong_to(:channel).counter_cache(true) }
    it { is_expected.to belong_to(:event).optional.counter_cache(true) }
  end

  describe "#clicked!" do
    it "increments the click count" do
      video = create(:video, click_count: 0, popularity: 0)
      video.clicked!
      expect(video.click_count).to eq(1)
      expect(video.popularity).to eq(1)
    end
  end

  describe ".filter_by_event_id" do
    it "returns video with corresponding orchestra name" do
      song = create(:song, artist: "Juan d'Arienzo")
      video = create(:video, song: song)
      result = described_class.filter_by_orchestra("Juan d'Arienzo")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_event_id" do
    it "returns video with corresponding event id" do
      song = create(:song, genre: "TANGO")
      video = create(:video, song: song)
      result = described_class.filter_by_genre("Tango")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_leader" do
    it "returns video with corresponding orchestra event_id" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader)
      result = described_class.filter_by_leader("Carlitos Espinoza")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_follower" do
    it "returns videos with matching follower name in video" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: follower)
      result = described_class.filter_by_follower("Noelia Hurtado")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_channel" do
    it "returns videos with matching channel name in video" do
      channel = create(:channel, title: "030 Tango")
      video = create(:video, channel: channel)
      result = described_class.filter_by_channel("030 Tango")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_event_id" do
    it "returns videos with matching event_id in video" do
      event = create(:event, title: "Embrace Berlin", id: 1)
      video = create(:video, event: event)
      result = described_class.filter_by_event_id("1")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_song_id" do
    it "returns videos with song_id in video" do
      song = create(:song, id: 1)
      video = create(:video, song: song)
      result = described_class.filter_by_song_id("1")
      expect(result).to include(video)
    end
  end

  describe ".filter_by_hd" do
    it "returns videos with hd: true" do
      video = create(:video, hd: true)
      result = described_class.filter_by_hd(true)
      expect(result).to include(video)
    end

    it "returns videos with hd: false" do
      video = create(:video, hd: false)
      result = described_class.filter_by_hd(false)
      expect(result).to include(video)
    end
  end

  describe "filter_by_hidden" do
    it "filter_by_hidden" do
      video = create(:video, hidden: true)
      result = described_class.hidden
      expect(result).to include(video)
    end
  end

  describe ".filter_by_not_hidden" do
    it "filter_by_not_hidden" do
      video = create(:video, hidden: false)
      result = described_class.not_hidden
      expect(result).to include(video)
    end
  end

  describe ".has_song" do
    it "returns videos with a song" do
      song = create(:song)
      video = create(:video, song: song)
      result = described_class.has_song
      expect(result).to include(video)
    end
  end

  describe ".not_hidden" do
    it "returns videos where hidden: false" do
      video = create(:video, hidden: false)
      result = described_class.not_hidden
      expect(result).to include(video)
    end
  end

  describe ".has_leader" do
    it "returns videos with a leader" do
      leader = create(:leader)
      video = create(:video, leader: leader)
      result = described_class.has_leader
      expect(result).to include(video)
    end
  end

  describe ".has_follower" do
    it "returns videos with a follower" do
      follower = create(:follower)
      video = create(:video, follower: follower)
      result = described_class.has_follower
      expect(result).to include(video)
    end
  end

  describe ".has_youtube_song" do
    it "returns videos with a youtube_song" do
      video = create(:video, youtube_song: "La Mentirosa")
      result = described_class.has_youtube_song
      expect(result).to include(video)
    end
  end

  describe ".missing_follower" do
    it "returns videos that are missing a follower" do
      video = create(:video)
      result = described_class.missing_follower
      expect(result).to include(video)
    end
  end

  describe ".missing_leader" do
    it "returns videos that are missing a leader" do
      video = create(:video)
      result = described_class.missing_leader
      expect(result).to include(video)
    end
  end

  describe ".missing_song" do
    it "returns videos that are missing a song" do
      video = create(:video)
      result = described_class.missing_song
      expect(result).to include(video)
    end
  end

  describe ".scanned_youtube_music" do
    it "returns videos that where we have tried to retrieve youtube's music identifacation" do
      video = create(:video, scanned_youtube_music: true)
      result = described_class.scanned_youtube_music
      expect(result).to include(video)
    end
  end

  describe ".not_scanned_youtube_music" do
    it "returns videos where we have not tried to retrieve youtube's music identifacation" do
      video = create(:video, scanned_youtube_music: false)
      result = described_class.not_scanned_youtube_music
      expect(result).to include(video)
    end
  end

  describe ".has_youtube_song" do
    it "returns videos with youtube_song" do
      video = create(:video, youtube_song: "La Mentirosa")
      result = described_class.has_youtube_song
      expect(result).to include(video)
    end
  end

  describe ".successful_acrcloud" do
    it "returns videos with a successful acr_response_code of 0" do
      video = create(:video, acr_response_code: 0)
      result = described_class.successful_acrcloud
      expect(result).to include(video)
    end

    it "does not return videos with a no match found acr_response_code" do
      video = create(:video, acr_response_code: 1001)
      result = described_class.successful_acrcloud
      expect(result).not_to include(video)
    end

    it "does not return videos where we haven't tried to recognize the audio using ACRCloud" do
      video = create(:video, acr_response_code: nil)
      result = described_class.successful_acrcloud
      expect(result).not_to include(video)
    end
  end

  describe ".not_successful_acrcloud" do
    it "returns videos with a 1001 acr_response_code" do
      video = create(:video, acr_response_code: 1001)
      result = described_class.not_successful_acrcloud
      expect(result).to include(video)
    end

    it "does not return videos with nil acr_response_code" do
      video = create(:video, acr_response_code: nil)
      result = described_class.not_successful_acrcloud
      expect(result).not_to include(video)
    end

    it "does not return videos with 0 acr_response_code" do
      video = create(:video, acr_response_code: 0)
      result = described_class.not_successful_acrcloud
      expect(result).not_to include(video)
    end
  end

  describe ".scanned_acrcloud" do
    it "does not return by videos with a nil acr response code" do
      video = create(:video, acr_response_code: nil)
      result = described_class.scanned_acrcloud
      expect(result).not_to include(video)
    end

    it "returns videos with 0 acr response code" do
      video = create(:video, acr_response_code: 0)
      result = described_class.scanned_acrcloud
      expect(result).to include(video)
    end

    it "returns videos with a 10001 acr response code" do
      video = create(:video, acr_response_code: 1001)
      result = described_class.scanned_acrcloud
      expect(result).to include(video)
    end
  end

  describe ".not_scanned_acrcloud" do
    it "return videos where we haven't tried to recognize the audio using ACRCloud" do
      video = create(:video, acr_response_code: nil)
      result = described_class.not_scanned_acrcloud
      expect(result).to include(video)
    end

    it "does not return videos with successful acr response code" do
      video = create(:video, acr_response_code: 0)
      result = described_class.not_scanned_acrcloud
      expect(result).not_to include(video)
    end

    it "does not return videos where acr_response_code was unsuccessful" do
      video = create(:video, acr_response_code: 1001)
      result = described_class.not_scanned_acrcloud
      expect(result).not_to include(video)
    end
  end

  describe ".with_song_title" do
    it "returns videos where Video Title matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, spotify_track_name: "No Vendra")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end

    it "returns videos where Video Youtube_Song matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, youtube_song: "No Vendra")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end

    it "returns videos where Video's song_title matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, title: "This is a video with No Vendra by Angel D'Agostino")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end

    it "returns videos where Video Description matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, description: "This is a video with No Vendra by Angel D'Agostino")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end

    it "returns videos where Video Tags matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, tags: "This is a video with No Vendra by Angel D'Agostino")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end

    it "returns videos where Video acr_cloud_track_name matches given song title" do
      song = create(:song, title: "No Vendrá")
      video = create(:video, acr_cloud_track_name: "This is a video with No Vendra by Angel D'Agostino")
      result = described_class.with_song_title(song.title)
      expect(result).to include(video)
    end
  end

  describe ".with_song_artist_keyword" do
    it "returns videos where last_name_search of song is found in video's spotify_artist_name" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_artist_name: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's spotify_artist_name_2" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_artist_name_2: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's youtube_artist" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, youtube_artist: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's description" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, description: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's title" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, title: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's tags" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, tags: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's spotify_album_name" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, spotify_album_name: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's acr_cloud_artist_name" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, acr_cloud_artist_name: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end

    it "returns videos where last_name_search of song is found in video's acr_cloud_artist_name_1" do
      song = create(:song, last_name_search: "Agostino")
      video = create(:video, acr_cloud_artist_name_1: "Angel D'Agostino")
      result = described_class.with_song_artist_keyword(song.last_name_search)
      expect(result).to include(video)
    end
  end

  describe ".with_dancer_name_in_title" do
    it "returns videos title matches leader name" do
      leader = create(:leader, name: "Carlitos Espinoza", first_name: "Carlitos", last_name: "Espinoza")
      video = create(:video, title: "Title with Carlitos Espinoza")
      result = described_class.with_dancer_name_in_title(leader.full_name)
      expect(result).to include(video)
    end

    it "returns videos title matches leader nickname" do
      leader = create(:leader, first_name: "Carlitos", last_name: "Espinoza")
      video = create(:video, title: "Title with Carlitos Espinoza")
      result = described_class.with_dancer_name_in_title(leader.full_name)
      expect(result).to include(video)
    end

    it "returns videos title matches follower name" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, title: "Title with Noelia Hurtado")
      result = described_class.with_dancer_name_in_title(follower.full_name)
      expect(result).to include(video)
    end

    it "returns videos title matches follower nickname" do
      follower = create(:follower, first_name: "Noelia", last_name: "Hurtado")
      video = create(:video, title: "Title with Noelia Hurtado")
      result = described_class.with_dancer_name_in_title(follower.full_name)
      expect(result).to include(video)
    end
  end

  describe ".title_match_missing_leader" do
    it "returns videos title matches leader name and the relation hasn't been made" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: nil, title: "Title with Carlitos Espinoza")
      result = described_class.title_match_missing_leader(leader.full_name)
      expect(result).to include(video)
    end

    it "does not return ideos title matches leader name and the relation hasn't been made" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader, title: "Title with Carlitos Espinoza")
      result = described_class.title_match_missing_leader(leader.full_name)
      expect(result).not_to include(video)
    end
  end

  describe ".title_match_missing_follower" do
    it "returns videos title matches follower name and the relation hasn't been made" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: nil, title: "Title with Noelia Hurtado")
      result = described_class.title_match_missing_follower(follower.full_name)
      expect(result).to include(video)
    end

    it "does not return ideos title matches follower name and the relation hasn't been made" do
      follower = create(:follower, name: "Carlitos Espinoza")
      video = create(:video, follower: follower, title: "Title with Carlitos Espinoza")
      result = described_class.title_match_missing_follower(follower.full_name)
      expect(result).not_to include(video)
    end
  end

  describe ".filter_by_query" do
    it "returns video with title that matches query" do
      video = create(:video, title: "Title with carlitos espinoza")
      VideosSearch.refresh
      result = described_class.filter_by_query("Carlitos Espinoza")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Carlitos Espin")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with description that matches query" do
      video = create(:video, description: "description with carlitos espinoza")
      VideosSearch.refresh
      result = described_class.filter_by_query("Carlitos Espinoza")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Carlitos Espin")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with leader name that matches query" do
      leader = create(:leader, name: "Carlitos Espinoza")
      video = create(:video, leader: leader)
      VideosSearch.refresh
      result = described_class.filter_by_query("Carlitos Espinoza")
      partial_match_result = described_class.filter_by_query("Carlitos Espin")
      no_result = described_class.filter_by_query("John Doe")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with leader nickname that matches query" do
      leader = create(:leader, nickname: "Carlitos")
      video = create(:video, leader: leader)
      VideosSearch.refresh
      result = described_class.filter_by_query("Carlitos")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Carli")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with follower name that matches query" do
      follower = create(:follower, name: "Noelia Hurtado")
      video = create(:video, follower: follower)
      VideosSearch.refresh
      result = described_class.filter_by_query("Noelia Hurtado")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("noeli")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with follower nickname that matches query" do
      follower = create(:follower, nickname: "Noelia")
      video = create(:video, follower: follower)
      VideosSearch.refresh
      result = described_class.filter_by_query("Noelia")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Noel")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with youtube_id that matches query" do
      video = create(:video, youtube_id: "s6iptZdCcG0")
      VideosSearch.refresh
      result = described_class.filter_by_query("s6iptZdCcG0")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("s6iptZdCcG")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with youtube_artist that matches query" do
      video = create(:video, youtube_artist: "Angel D'Agostino")
      VideosSearch.refresh
      result = described_class.filter_by_query("Agostino")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Agostin")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with youtube_song that matches query" do
      video = create(:video, youtube_song: "No Vendrá")
      VideosSearch.refresh
      result = described_class.filter_by_query("no vendrá")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("no vend")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with spotify_track_name that matches query" do
      video = create(:video, spotify_track_name: "No Vendrá")
      VideosSearch.refresh
      result = described_class.filter_by_query("no vendrá")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("no vend")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with spotify_artist_name that matches query" do
      video = create(:video, spotify_artist_name: "Angel D'Agostino")
      VideosSearch.refresh
      result = described_class.filter_by_query("agostino")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Angel D'Agosti")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with channel title that matches query" do
      channel = create(:channel, title: "030 Tango")
      video = create(:video, channel: channel)
      VideosSearch.refresh
      result = described_class.filter_by_query("030 tango")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("030 T")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with channel_id that matches query" do
      channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
      video = create(:video, channel: channel)
      VideosSearch.refresh
      result = described_class.filter_by_query("UCtdgMR0bmogczrZNpPaO66Q")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("UCtdgMR0bmogczrZNpPaO")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with song genre that matches query" do
      song = create(:song, genre: "Tango")
      video = create(:video, song: song)
      VideosSearch.refresh
      result = described_class.filter_by_query("tango")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("tang")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with song title that matches query" do
      song = create(:song, title: "La Mentirosa")
      video = create(:video, song: song)
      VideosSearch.refresh
      result = described_class.filter_by_query("mentirosa")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("menti")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end

    it "returns video with song artist that matches query" do
      song = create(:song, artist: "Angel D'Agostino")
      video = create(:video, song: song)
      VideosSearch.refresh
      result = described_class.filter_by_query("d'agostino")
      no_result = described_class.filter_by_query("John Doe")
      partial_match_result = described_class.filter_by_query("Agosti")
      expect(result).to include(video)
      expect(no_result).not_to include(video)
      expect(partial_match_result).to include(video)
    end
  end
end
