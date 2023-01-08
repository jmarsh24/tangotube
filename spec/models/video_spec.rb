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
require "rails_helper"

RSpec.describe Video do
  describe "#clicked!" do
    it "increments the click count" do
      video = create(:video, click_count: 0, popularity: 0)
      video.clicked!
      expect(video.click_count).to eq(1)
      expect(video.popularity).to eq(1)
    end
  end

  describe "scopes" do
    describe ".filter_by_orchestra" do
      it "returns videos with corresponding orchestra name" do
        song = create(:song, artist: "Juan d'Arienzo")
        video = create(:video, song:)
        expect(described_class.filter_by_orchestra("Juan d'Arienzo")).to eq [
          video
        ]
      end

      it "does not return videos without corresponding orchestra name" do
        video = create(:video)
        expect(
          described_class.filter_by_orchestra("Juan d'Arienzo")
        ).not_to eq [video]
      end
    end

    describe ".filter_by_genre" do
      it "returns video with corresponding event id" do
        song = create(:song, genre: "TANGO")
        video = create(:video, song:)
        expect(described_class.filter_by_genre("Tango")).to eq [video]
      end

      it "does not return videos without corresponding event id" do
        video = create(:video)
        expect(described_class.filter_by_genre("Tango")).not_to eq [video]
      end
    end

    describe ".filter_by_leader" do
      it "returns video with corresponding orchestra event_id" do
        leader = create(:leader)
        video = create(:video, leader:)
        expect(described_class.filter_by_leader(leader.name)).to eq [video]
      end

      it "does not return video without corresponding orchestra event_id" do
        video = create(:video)
        expect(described_class.filter_by_leader("0")).not_to eq [video]
      end
    end

    describe ".filter_by_follower_id" do
      it "returns videos with matching follower" do
        follower = create(:follower)
        video = create(:video, follower:)
        expect(described_class.filter_by_follower(follower.name)).to eq [video]
      end

      it "does not return videos with incorrect follower id" do
        video = create(:video)
        expect(described_class.filter_by_follower("0")).not_to eq [video]
      end
    end

    describe ".filter_by_channel" do
      it "returns videos with matching channel" do
        channel = create(:channel)
        video = create(:video, channel:)
        expect(described_class.filter_by_channel(channel.channel_id)).to eq [video]
      end

      it "does not return videos with incorrect channel id" do
        video = create(:video)
        expect(described_class.filter_by_channel("0")).not_to eq [video]
      end
    end

    describe ".filter_by_event_id" do
      it "returns videos with matching event_id in video" do
        event = create(:event)
        video = create(:video, event:)
        expect(described_class.filter_by_event_id(event.id)).to eq [video]
      end

      it "does not return videos without matching event_id in video" do
        video = create(:video)
        expect(described_class.filter_by_event_id("1")).not_to eq [video]
      end
    end

    describe ".filter_by_song_id" do
      it "returns videos with song_id in video" do
        song = create(:song)
        video = create(:video, song:)
        expect(described_class.filter_by_song_id(song.id)).to eq [video]
      end

      it "does not return videos without matching song_id" do
        video = create(:video)
        expect(described_class.filter_by_song_id("1")).not_to eq [video]
      end
    end

    describe ".filter_by_hd" do
      it "returns videos with hd: true" do
        video = create(:video, hd: true)
        expect(described_class.filter_by_hd(true)).to eq [video]
      end

      it "returns videos with hd: false" do
        video = create(:video, hd: false)
        expect(described_class.filter_by_hd(false)).to eq [video]
      end
    end

    describe ".filter_by_hidden" do
      it "filter_by_hidden" do
        video = create(:video, hidden: true)
        expect(described_class.hidden).to eq [video]
      end
    end

    describe ".filter_by_not_hidden" do
      it "filter_by_not_hidden" do
        video = create(:video, hidden: false)
        expect(described_class.not_hidden).to eq [video]
      end
    end

    describe ".has_song" do
      it "returns videos with a song" do
        song = create(:song)
        video = create(:video, song:)
        expect(described_class.has_song).to eq [video]
      end

      it "does not return videos without song" do
        video = create(:video)
        expect(described_class.has_song).not_to eq [video]
      end
    end

    describe ".not_hidden" do
      it "returns videos where hidden: false" do
        video = create(:video, hidden: false)
        expect(described_class.not_hidden).to eq [video]
      end

      it "does not return videos where hidden: true" do
        video = create(:video, hidden: true)
        expect(described_class.not_hidden).not_to eq [video]
      end
    end

    describe ".has_leader" do
      it "returns videos with a leader" do
        leader = create(:leader)
        video = create(:video, leader:)
        expect(described_class.has_leader).to eq [video]
      end

      it "does not return videos with leader" do
        video = create(:video)
        expect(described_class.has_leader).not_to eq [video]
      end
    end

    describe ".has_follower" do
      it "returns videos with a follower" do
        follower = create(:follower)
        video = create(:video, follower:)
        expect(described_class.has_follower).to eq [video]
      end

      it "does not return videos without a follower" do
        video = create(:video)
        expect(described_class.has_follower).not_to eq [video]
      end
    end

    describe ".missing_follower" do
      it "returns videos that are missing a follower" do
        video = create(:video)
        expect(described_class.missing_follower).to eq [video]
      end

      it "does not return videos with a follower" do
        follower = create(:follower)
        video = create(:video, follower:)
        expect(described_class.missing_follower).not_to eq [video]
      end
    end

    describe ".missing_leader" do
      it "returns videos that are missing a leader" do
        video = create(:video)
        expect(described_class.missing_leader).to eq [video]
      end

      it "does not return videos with a leader" do
        leader = create(:leader)
        video = create(:video, leader:)
        expect(described_class.missing_leader).not_to eq [video]
      end
    end

    describe ".missing_song" do
      it "returns videos that are missing a song" do
        video = create(:video)
        expect(described_class.missing_song).to eq [video]
      end

      it "does not return videos with a song" do
        song = create(:song)
        video = create(:video, song:)
        expect(described_class.missing_song).not_to eq [video]
      end
    end

    describe ".scanned_youtube_music" do
      it "returns videos that where we have tried to retrieve youtube's music identification" do
        video = create(:video, scanned_youtube_music: true)
        expect(described_class.scanned_youtube_music).to eq [video]
      end

      it "does not return videos that where we have not tried to retrieve youtube's music identification" do
        video = create(:video, scanned_youtube_music: false)
        expect(described_class.scanned_youtube_music).not_to eq [video]
      end
    end

    describe ".not_scanned_youtube_music" do
      it "returns videos where we have not tried to retrieve youtube's music identifacation" do
        video = create(:video, scanned_youtube_music: false)
        expect(described_class.not_scanned_youtube_music).to eq [video]
      end

      it "does not returns videos where we have tried to retrieve youtube's music identifacation" do
        video = create(:video, scanned_youtube_music: true)
        expect(described_class.not_scanned_youtube_music).not_to eq [video]
      end
    end

    describe ".has_youtube_song" do
      it "returns videos with youtube_song" do
        video = create(:video, youtube_song: "La Mentirosa")
        expect(described_class.has_youtube_song).to eq [video]
      end

      it "does not returns videos without youtube_song" do
        video = create(:video)
        expect(described_class.has_youtube_song).not_to eq [video]
      end
    end

    describe ".successful_acrcloud" do
      it "returns videos with a successful acr_response_code of 0" do
        video = create(:video, acr_response_code: 0)
        expect(described_class.successful_acrcloud).to eq [video]
      end

      it "does not return videos with a no match found acr_response_code" do
        video = create(:video, acr_response_code: 1001)
        expect(described_class.successful_acrcloud).not_to eq [video]
      end

      it "does not return videos where we haven't tried to recognize the audio using ACRCloud" do
        video = create(:video, acr_response_code: nil)
        expect(described_class.successful_acrcloud).not_to eq [video]
      end
    end

    describe ".not_successful_acrcloud" do
      it "returns videos with a 1001 acr_response_code" do
        video = create(:video, acr_response_code: 1001)
        expect(described_class.not_successful_acrcloud).to eq [video]
      end

      it "does not return videos with nil acr_response_code" do
        video = create(:video, acr_response_code: nil)
        expect(described_class.not_successful_acrcloud).not_to eq [video]
      end

      it "does not return videos with 0 acr_response_code" do
        video = create(:video, acr_response_code: 0)
        expect(described_class.not_successful_acrcloud).not_to eq [video]
      end
    end

    describe ".scanned_acrcloud" do
      it "does not return by videos with a nil acr response code" do
        video = create(:video, acr_response_code: nil)
        expect(described_class.scanned_acrcloud).not_to eq [video]
      end

      it "returns videos with 0 acr response code" do
        video = create(:video, acr_response_code: 0)
        expect(described_class.scanned_acrcloud).to eq [video]
      end

      it "returns videos with a 10001 acr response code" do
        video = create(:video, acr_response_code: 1001)
        expect(described_class.scanned_acrcloud).to eq [video]
      end
    end

    describe ".not_scanned_acrcloud" do
      it "return videos where we haven't tried to recognize the audio using ACRCloud" do
        video = create(:video, acr_response_code: nil)
        expect(described_class.not_scanned_acrcloud).to eq [video]
      end

      it "does not return videos with successful acr response code" do
        video = create(:video, acr_response_code: 0)
        expect(described_class.not_scanned_acrcloud).not_to eq [video]
      end

      it "does not return videos where acr_response_code was unsuccessful" do
        video = create(:video, acr_response_code: 1001)
        expect(described_class.not_scanned_acrcloud).not_to eq [video]
      end
    end

    describe ".with_song_title" do
      it "returns videos where Video Title matches given song title" do
        song = create(:song, title: "No Vendrá")
        video = create(:video, spotify_track_name: "No Vendra")
        expect(described_class.with_song_title(song.title)).to eq [video]
      end

      it "returns videos where Video Youtube_Song matches given song title" do
        song = create(:song, title: "No Vendrá")
        video = create(:video, youtube_song: "No Vendra")
        expect(described_class.with_song_title(song.title)).to eq [video]
      end

      it "returns videos where Video's song_title matches given song title" do
        song = create(:song, title: "No Vendrá")
        video =
          create(
            :video,
            title: "This is a video with No Vendra by Angel D'Agostino"
          )
        expect(described_class.with_song_title(song.title)).to eq [video]
      end

      it "returns videos where Video Description matches given song title" do
        song = create(:song, title: "No Vendrá")
        video =
          create(
            :video,
            description: "This is a video with No Vendra by Angel D'Agostino"
          )
        expect(described_class.with_song_title(song.title)).to eq [video]
      end

      it "returns videos where Video Tags matches given song title" do
        song = create(:song, title: "No Vendrá")
        video =
          create(
            :video,
            tags: "This is a video with No Vendra by Angel D'Agostino"
          )
        expect(described_class.with_song_title(song.title)).to eq [video]
      end

      it "returns videos where Video acr_cloud_track_name matches given song title" do
        song = create(:song, title: "No Vendrá")
        video =
          create(
            :video,
            acr_cloud_track_name:
              "This is a video with No Vendra by Angel D'Agostino"
          )
        expect(described_class.with_song_title(song.title)).to eq [video]
      end
    end

    describe ".with_song_artist_keyword" do
      it "returns videos where last_name_search of song is found in video's spotify_artist_name" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, spotify_artist_name: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's spotify_artist_name_2" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, spotify_artist_name_2: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's youtube_artist" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, youtube_artist: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's description" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, description: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's title" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, title: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's tags" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, tags: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's spotify_album_name" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, spotify_album_name: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's acr_cloud_artist_name" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, acr_cloud_artist_name: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end

      it "returns videos where last_name_search of song is found in video's acr_cloud_artist_name_1" do
        song = create(:song, last_name_search: "Agostino")
        video = create(:video, acr_cloud_artist_name_1: "Angel D'Agostino")
        expect(
          described_class.with_song_artist_keyword(song.last_name_search)
        ).to eq [video]
      end
    end

    describe ".with_dancer_name_in_title" do
      it "returns videos title matches leader name" do
        leader =
          create(
            :leader,
            name: "Carlitos Espinoza",
            first_name: "Carlitos",
            last_name: "Espinoza"
          )
        video = create(:video, title: "Title with Carlitos Espinoza")
        expect(
          described_class.with_dancer_name_in_title(leader.full_name)
        ).to eq [video]
      end

      it "returns videos title matches leader nickname" do
        leader = create(:leader, first_name: "Carlitos", last_name: "Espinoza")
        video = create(:video, title: "Title with Carlitos Espinoza")
        expect(
          described_class.with_dancer_name_in_title(leader.full_name)
        ).to eq [video]
      end

      it "returns videos title matches follower name" do
        follower = create(:follower, name: "Noelia Hurtado")
        video = create(:video, title: "Title with Noelia Hurtado")
        expect(
          described_class.with_dancer_name_in_title(follower.full_name)
        ).to eq [video]
      end

      it "returns videos title matches follower nickname" do
        follower = create(:follower, first_name: "Noelia", last_name: "Hurtado")
        video = create(:video, title: "Title with Noelia Hurtado")
        expect(
          described_class.with_dancer_name_in_title(follower.full_name)
        ).to eq [video]
      end
    end

    describe ".title_match_missing_leader" do
      it "returns videos title matches leader name and the relation hasn't been made" do
        leader = create(:leader, name: "Carlitos Espinoza")
        video =
          create(:video, leader: nil, title: "Title with Carlitos Espinoza")
        expect(
          described_class.title_match_missing_leader(leader.full_name)
        ).to eq [video]
      end

      it "does not return ideos title matches leader name and the relation hasn't been made" do
        leader = create(:leader, name: "Carlitos Espinoza")
        video =
          create(:video, leader:, title: "Title with Carlitos Espinoza")
        expect(
          described_class.title_match_missing_leader(leader.full_name)
        ).not_to eq [video]
      end
    end

    describe ".title_match_missing_follower" do
      it "returns videos title matches follower name and the relation hasn't been made" do
        follower = create(:follower, name: "Noelia Hurtado")
        video =
          create(:video, follower: nil, title: "Title with Noelia Hurtado")
        expect(
          described_class.title_match_missing_follower(follower.full_name)
        ).to eq [video]
      end

      it "does not return ideos title matches follower name and the relation hasn't been made" do
        follower = create(:follower, name: "Carlitos Espinoza")
        video =
          create(
            :video,
            follower:,
            title: "Title with Carlitos Espinoza"
          )
        expect(
          described_class.title_match_missing_follower(follower.full_name)
        ).not_to eq [video]
      end
    end

    describe ".filter_by_query" do
      it "returns video with title that matches query" do
        video = create(:video, title: "Title with carlitos espinoza")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Carlitos Espinoza")).to eq [
          video
        ]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("Carlitos Espin")).to eq [video]
      end

      it "returns video with description that matches query" do
        video =
          create(:video, description: "description with carlitos espinoza")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Carlitos Espinoza")).to eq [
          video
        ]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("Carlitos Espin")).to eq [video]
      end

      it "returns video with leader name that matches query" do
        leader = create(:leader, name: "Carlitos Espinoza")
        video = create(:video, leader:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Carlitos Espinoza")).to eq [
          video
        ]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("Carlitos Espin")).to eq [video]
      end

      it "returns video with leader nickname that matches query" do
        leader = create(:leader, nickname: "Carlitos")
        video = create(:video, leader:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Carlitos")).to eq [video]
        expect(described_class.filter_by_query("No Match")).not_to eq [video]
        expect(described_class.filter_by_query("Carli")).to eq [video]
      end

      it "returns video with follower name that matches query" do
        follower = create(:follower, name: "Noelia Hurtado")
        video = create(:video, follower:)
        described_class.refresh_materialized_view

        expect(described_class.filter_by_query("Noelia Hurtado")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("noeli")).to eq [video]
      end

      it "returns video with follower nickname that matches query" do
        follower = create(:follower, nickname: "Noelia")
        video = create(:video, follower:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Noelia")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("Noel")).to eq [video]
      end

      it "returns video with youtube_id that matches query" do
        video = create(:video, youtube_id: "s6iptZdCcG0")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("s6iptZdCcG0")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("s6iptZdCcG")).to eq [video]
      end

      it "returns video with youtube_artist that matches query" do
        video = create(:video, youtube_artist: "Angel D'Agostino")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("dAgostino")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("dAgostin")).to eq [video]
      end

      it "returns video with youtube_song that matches query" do
        video = create(:video, youtube_song: "No Vendrá")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("no vendrá")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("no vend")).to eq [video]
      end

      it "returns video with spotify_track_name that matches query" do
        video = create(:video, spotify_track_name: "No Vendrá")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("no vendrá")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("no vend")).to eq [video]
      end

      it "returns video with spotify_artist_name that matches query" do
        video = create(:video, spotify_artist_name: "Angel D'Agostino")
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("Dagostino")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("Angel D'Agosti")).to eq [video]
      end

      it "returns video with channel title that matches query" do
        channel = create(:channel, title: "030 Tango")
        video = create(:video, channel:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("030 tango")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("030 T")).to eq [video]
      end

      it "returns video with channel_id that matches query" do
        channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
        video = create(:video, channel:)
        described_class.refresh_materialized_view
        expect(
          described_class.filter_by_query("UCtdgMR0bmogczrZNpPaO66Q")
        ).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("UCtdgMR0bmogczrZNpPaO")).to eq [
          video
        ]
      end

      it "returns video with song genre that matches query" do
        song = create(:song, genre: "Tango")
        video = create(:video, song:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("tango")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("tang")).to eq [video]
      end

      it "returns video with song title that matches query" do
        song = create(:song, title: "La Mentirosa")
        video = create(:video, song:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("mentirosa")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("menti")).to eq [video]
      end

      it "returns video with song artist that matches query" do
        song = create(:song, artist: "Angel D'Agostino")
        video = create(:video, song:)
        described_class.refresh_materialized_view
        expect(described_class.filter_by_query("d'agostino")).to eq [video]
        expect(described_class.filter_by_query("John Doe")).not_to eq [video]
        expect(described_class.filter_by_query("DAgosti")).to eq [video]
      end
    end

    describe ".filter_by_most_viewed_videos_monthly" do
      it "returns video that has been viewed within month" do
        video1 = create(:video, youtube_id: "video_1")
        video2 = create(:video, youtube_id: "video_2")
        video3 = create(:video, youtube_id: "video_3")
        allow(Ahoy::Event).to receive(:most_viewed_videos_by_month)
          .and_return(["video_3", "video_2", "video_1"])
        youtube_id_result = described_class.most_viewed_videos_by_month
        expect(youtube_id_result).to eq([video1, video2, video3])
      end
    end

    describe ".paginate" do
      it "limits pagination to 1" do
        create_list(:video, 3)
        page1 = described_class.paginate(1, 2)
        page2 = described_class.paginate(2, 2)
        page3 = described_class.paginate(3, 2)
        expect(page1.count).to eq(2)
        expect(page2.count).to eq(1)
        expect(page3.count).to eq(0)
      end
    end
  end
end
