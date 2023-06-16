# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video do
  fixtures :all

  describe ".channel" do
    it "returns the channel for the video" do
      video = videos(:video_1_featured)

      expect(video.channel).to eq(channels(:jkukla_video))
    end
  end

  describe ".exclude_youtube_id" do
    it "returns videos that do not have the specified youtube_id" do
      video = videos(:video_1_featured)

      expect(Video.exclude_youtube_id(video.youtube_id)).not_to include(video)
    end
  end

  describe ".featured" do
    it "returns videos that are featured" do
      video = videos(:video_1_featured)

      expect(Video.featured).to include(video)
    end
  end

  describe ".not_featured" do
    it "returns videos that are not featured" do
      video = videos(:video_1_featured)

      expect(Video.not_featured).not_to include(video)
    end
  end

  describe ".follower" do
    it "returns videos with the specified follower" do
      video = videos(:video_1_featured)

      expect(Video.follower("noelia-hurtado")).to include(video)
    end
  end

  describe ".leader" do
    it "returns videos with the specified leader" do
      video = videos(:video_1_featured)

      expect(Video.leader("carlitos-espinoza")).to include(video)
    end
  end

  describe ".genre" do
    it "returns videos with the specified genre" do
      video = videos(:video_1_featured)

      expect(Video.genre("tango")).to include(video)
    end
  end

  describe ".has_leader" do
    it "returns videos that have a leader" do
      video = videos(:video_1_featured)

      expect(Video.has_leader).to include(video)
    end
  end

  describe ".has_follower" do
    it "returns videos that have a follower" do
      video = videos(:video_1_featured)

      expect(Video.has_follower).to include(video)
    end
  end

  describe ".hd" do
    it "returns videos that are hd" do
      video = videos(:video_1_featured)

      expect(Video.hd(true)).to include(video)
    end
  end

  describe ".hidden" do
    it "returns videos that are hidden" do
      video = videos(:video_1_featured)
      video.update!(hidden: true)

      expect(Video.hidden).to include(video)
    end
  end

  describe ".not_hidden" do
    it "returns videos that are not hidden" do
      video = videos(:video_1_featured)

      expect(Video.not_hidden).to include(video)
    end
  end

  describe ".orchestra" do
    it "returns videos with the specified orchestra" do
      video = videos(:video_1_featured)
      orchestra = orchestras(:di_sarli)
      expect(Video.orchestra(orchestra.slug)).to include(video)
    end
  end

  describe ".song" do
    it "returns videos with the specified song" do
      video = videos(:video_1_featured)
      song = songs(:cuando_el_amor_muere)

      expect(Video.song(song.slug)).to include(video)
    end
  end

  describe ".event" do
    it "returns videos with the specified event" do
      video = videos(:video_1_featured)
      event = events(:academia_de_tango)

      expect(Video.event(event.slug)).to include(video)
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
      video = videos(:video_1_featured)

      expect(Video.year(2014)).to include(video)
    end
  end

  describe ".within_week_of" do
    it "returns videos that are within a week of the specified date" do
      video = videos(:video_1_featured)

      expect(Video.within_week_of(video.upload_date)).to include(video)
    end
  end

  describe ".liked" do
    it "returns videos that are liked by the specified user" do
      video = videos(:video_1_featured)
      user = users(:regular)
      video.upvote_by user, vote_scope: "like"

      expect(Video.liked(users(:regular))).to include(video)
    end
  end

  describe "#clicked!" do
    it "increases click_count by 1" do
      video = videos(:video_1_featured)
      expect { video.clicked! }.to change(video, :click_count).by(1)
    end
  end

  describe "#featured?" do
    it "returns true when video is featured" do
      video = videos(:video_1_featured)
      video.update!(featured: true)

      expect(video.featured?).to be(true)
    end

    it "returns false when video is not featured" do
      video = videos(:video_1_featured)

      expect(video.featured?).to be(true)
    end
  end

  describe "#to_param" do
    it "returns youtube_id" do
      video = videos(:video_1_featured)
      expect(video.to_param).to eq(video.youtube_id)
    end
  end
end
