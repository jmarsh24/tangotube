# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  title               :text
#  youtube_id          :string           not null
#  description         :string
#  duration            :integer
#  view_count          :integer
#  song_id             :bigint
#  acr_response_code   :integer
#  channel_id          :bigint
#  hidden              :boolean          default(FALSE)
#  hd                  :boolean          default(FALSE)
#  like_count          :integer          default(0)
#  event_id            :bigint
#  featured            :boolean          default(FALSE)
#  metadata            :jsonb
#  tags                :text             default([]), is an Array
#  upload_date         :date
#  upload_date_year    :integer
#  youtube_view_count  :integer
#  youtube_like_count  :integer
#  youtube_tags        :text             default([]), is an Array
#  metadata_updated_at :datetime
#  normalized_title    :string
#
require "rails_helper"

RSpec.describe Video do
  fixtures :all

  describe ".channel" do
    it "returns the channel for the video" do
      videos = Video.channel(channels(:"030tango").channel_id)

      expect(videos).to match_array([videos(:video_3_featured)])
      expect(videos).not_to match_array([videos(:video_1_featured)])
    end
  end

  describe ".exclude_youtube_id" do
    it "returns videos that do not have the specified youtube_id" do
      video = videos(:video_1_featured)
      videos = Video.exclude_youtube_id(video.youtube_id)

      expect(videos).not_to include(video)
      expect(videos).to include(videos(:video_2_featured))
    end
  end

  describe ".featured" do
    it "returns videos that are featured" do
      featured_videos = Video.featured

      expect(featured_videos).to include(videos(:video_1_featured))
      expect(featured_videos).not_to include(videos(:video_5))
    end
  end

  describe ".not_featured" do
    it "returns videos that are not featured" do
      not_featured_videos = Video.not_featured

      expect(not_featured_videos).to include(videos(:video_5))
      expect(not_featured_videos).not_to include(videos(:video_1_featured))
    end
  end

  describe ".follower" do
    it "returns videos with the specified follower" do
      corina_follower_videos = Video.follower("corina-herrera")

      expect(corina_follower_videos).to match_array([videos(:video_6)])
      expect(corina_follower_videos).not_to include(videos(:video_5))
    end
  end

  describe ".leader" do
    it "returns videos with the specified leader" do
      corina_leader_videos = Video.leader("corina-herrera")

      expect(corina_leader_videos).to match_array([videos(:video_5)])
      expect(corina_leader_videos).not_to include(videos(:video_6))
    end
  end

  describe ".genre" do
    it "returns videos with the specified genre" do
      vals_videos = Video.genre("vals")

      expect(vals_videos).to match_array([videos(:video_4_featured)])
      expect(vals_videos).not_to include(videos(:video_5))
    end
  end

  describe ".has_leader" do
    it "returns videos that have a leader" do
      videos_with_leaders = Video.has_leader

      expect(videos_with_leaders).to match_array(Video.all)
      video = videos(:video_1_featured)
      video.couples.each(&:destroy!)
      videos(:video_1_featured).leaders.each(&:destroy!)
      videos_with_leaders.reload
      expect(videos_with_leaders).not_to include(videos(:video_1_featured))
    end
  end

  describe ".has_follower" do
    it "returns videos that have a follower" do
      videos_with_followers = Video.has_follower

      expect(videos_with_followers).to match_array(Video.all)
      video = videos(:video_1_featured)
      video.couples.each(&:destroy!)
      videos(:video_1_featured).followers.each(&:destroy!)
      videos_with_followers.reload
      expect(videos_with_followers).not_to include(video)
    end
  end

  describe ".hd" do
    it "returns videos that are hd" do
      hd_videos = Video.hd(true)

      expect(hd_videos).to include(videos(:video_1_featured))
      expect(hd_videos).not_to include(videos(:video_5))
    end
  end

  describe ".hidden" do
    it "returns videos that are hidden" do
      videos(:video_1_featured).update!(hidden: true)
      hidden_videos = Video.hidden

      expect(hidden_videos).to include(videos(:video_1_featured))
      expect(hidden_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".not_hidden" do
    it "returns videos that are not hidden" do
      videos(:video_1_featured).update!(hidden: true)
      hidden_videos = Video.hidden

      expect(hidden_videos).to include(videos(:video_1_featured))
      expect(hidden_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".orchestra" do
    it "returns videos with the specified orchestra" do
      disarli_videos = Video.orchestra(orchestras(:di_sarli).slug)

      expect(disarli_videos).to include(videos(:video_1_featured))
      expect(disarli_videos).not_to include(videos(:video_5))
    end
  end

  describe ".song" do
    it "returns videos with the specified song" do
      cuando_el_amor_muere_videos = Video.song(songs(:cuando_el_amor_muere).slug)

      expect(cuando_el_amor_muere_videos).to include(videos(:video_1_featured))
      expect(cuando_el_amor_muere_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".event" do
    it "returns videos with the specified event" do
      event_videos = Video.event(events(:academia_de_tango).slug)

      expect(event_videos).to include(videos(:video_1_featured))
      expect(event_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".watched" do
    it "returns videos that are watched by the specified user" do
      user = users(:regular)
      watched_video = videos(:video_1_featured)
      unwatched_video = videos(:video_2_featured)

      Watch.create(user:, video: watched_video)

      watched_videos = Video.watched(user)

      expect(watched_videos).to include(watched_video)
      expect(watched_videos).not_to include(unwatched_video)
    end
  end

  describe ".not_watched" do
    it "returns videos that are not watched by the specified user" do
      user = users(:regular)
      watched_video = videos(:video_1_featured)
      unwatched_video = videos(:video_2_featured)

      Watch.create(user:, video: watched_video)

      unwatched_videos = Video.not_watched(user)

      expect(unwatched_videos).to include(unwatched_video)
      expect(unwatched_videos).not_to include(watched_video)
    end
  end

  describe ".year" do
    it "returns videos with the specified year" do
      year_videos = Video.year("2014")

      expect(year_videos).to include(videos(:video_1_featured))
      expect(year_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".within_week_of" do
    it "returns videos that are within a week of the specified date" do
      videos(:video_2_featured).update!(upload_date: videos(:video_1_featured).upload_date + 6.days)
      videos_within_week_of = Video.within_week_of(videos(:video_1_featured).upload_date)

      expect(videos_within_week_of).to match_array([videos(:video_1_featured), videos(:video_2_featured)])
      expect(videos_within_week_of).not_to include(videos(:video_3_featured))
    end
  end

  describe ".liked" do
    it "returns videos that are liked by the specified user" do
      liked_video = videos(:video_1_featured)
      user = users(:regular)
      user.likes.create!(likeable: liked_video)
      liked_videos = Video.liked(user)

      expect(liked_videos).to include(liked_video)
      expect(liked_videos).not_to include(videos(:video_2_featured))
    end
  end

  describe ".search" do
    it "returns videos that match the search term" do
      VideoSearch.refresh

      mispelled_search = Video.search("carlitos espnosa")

      video_ids = mispelled_search.map(&:id)

      expect(video_ids).to include(videos(:video_1_featured).id, videos(:video_4_featured).id)
      expect(video_ids).not_to include(videos(:video_2_featured).id)
    end
  end

  describe ".fuzzy_titles" do
    it "returns videos that match the search term" do
      video = Video.create!(
        youtube_id: "123",
        title: "Pablo Rodriguez & Corina Herrera - La Vi Llegar - Miguel Calo - MSTF 2016",
        channel: channels(:"030tango")
      )
      results = Video.fuzzy_titles("Miguel Calvo")

      expect(results).not_to include(video)
    end
  end

  describe ".music_recognized" do
    context "when video has acr_response code of 1001" do
      it "does not include the video" do
        recognized_music_video = videos(:video_1_featured)
        recognized_music_video.update!(acr_response_code: 1001)

        expect(Video.music_recognized).not_to include(recognized_music_video)
      end
    end

    context "when video has acr_response code of 0" do
      it "does not include the video" do
        recognized_music_video = videos(:video_1_featured)
        recognized_music_video.update!(acr_response_code: 0)

        expect(Video.music_recognized).to include(recognized_music_video)
      end
    end

    context "when video has acr_response code of nil" do
      it "includes the video" do
        music_recognized_video = videos(:video_1_featured)
        music_recognized_video.update!(acr_response_code: nil)

        expect(Video.music_recognized).not_to include(music_recognized_video)
      end
    end
  end

  describe ".music_unrecognized" do
    it "returns videos that have acr_response_code of nil" do
      music_unrecognized_video = videos(:video_1_featured)
      music_unrecognized_video.update!(acr_response_code: nil)

      expect(Video.music_unrecognized).to include(music_unrecognized_video)
    end

    it "returns videos that have acr_response_code of 3003" do
      music_unrecognized_video = videos(:video_1_featured)
      music_unrecognized_video.update!(acr_response_code: 3003)

      expect(Video.music_unrecognized).to include(music_unrecognized_video)
    end

    it "does not return videos that have acr_response_code of 0" do
      music_unrecognized_video = videos(:video_1_featured)
      music_unrecognized_video.update!(acr_response_code: 0)

      expect(Video.music_unrecognized).not_to include(music_unrecognized_video)
    end

    it "does not return videos that have acr_response_code of 1001" do
      music_unrecognized_video = videos(:video_1_featured)
      music_unrecognized_video.update!(acr_response_code: 1001)

      expect(Video.music_unrecognized).not_to include(music_unrecognized_video)
    end
  end

  describe "#featured?" do
    it "returns true when video is featured" do
      expect(videos(:video_1_featured).featured?).to be(true)
    end

    it "returns false when video is not featured" do
      expect(videos(:video_5).featured?).to be(false)
    end
  end

  describe "#to_param" do
    it "returns youtube_id" do
      video = videos(:video_1_featured)

      expect(video.to_param).to eq(video.youtube_id)
    end
  end

  describe "#hd_duration_data" do
    it "returns the duration in seconds" do
      video = videos(:video_1_featured)

      expect(video.hd_duration_data).to eq("HD 02:47")
    end
  end
end
