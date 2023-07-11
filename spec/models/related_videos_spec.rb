# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::RelatedVideos do
  fixtures :all

  describe "#with_same_dancers" do
    it "returns videos with same leader and follower" do
      recommendation = described_class.new(videos(:video_1_featured))

      expect(recommendation.with_same_dancers).to match_array([videos(:video_4_featured)])
    end
  end

  describe "#with_same_event" do
    it "returns videos with same event" do
      video = videos(:video_1_featured)
      recommendation = described_class.new(video)
      video_same_event = Video.create!(
        event: video.event,
        channel: video.channel,
        youtube_id: SecureRandom.hex,
        upload_date: video.upload_date + 5.days,
        hidden: false,
        title: "unnecessary",
        description: "unnecessary"
      )

      expect(recommendation.with_same_event).to match_array([video_same_event])
    end
  end

  describe "#with_same_song" do
    it "returns videos with same song" do
      video = videos(:video_1_featured)
      recommendation = described_class.new(video)
      video_same_song = Video.create!(
        event: video.event,
        channel: video.channel,
        song: video.song,
        youtube_id: "1234",
        upload_date: video.upload_date + 5.days,
        hidden: false,
        title: "unnecessary",
        description: "unnecessary"
      )
      DancerVideo.create!(dancer: video.leaders.first, video: video_same_song, role: "leader")
      DancerVideo.create!(dancer: video.followers.first, video: video_same_song, role: "follower")

      expect(recommendation.with_same_song).to match_array([video_same_song])
    end
  end

  describe "#with_same_channel" do
    it "returns videos with same channel" do
      video = videos(:video_1_featured)
      recommendation = described_class.new(video)
      video_same_channel = Video.create!(
        event: video.event,
        channel: video.channel,
        song: video.song,
        youtube_id: "1234",
        upload_date: video.upload_date + 5.days,
        hidden: false,
        title: "unnecessary",
        description: "unnecessary"
      )
      DancerVideo.create!(dancer: video.leaders.first, video: video_same_channel, role: "leader")
      DancerVideo.create!(dancer: video.followers.first, video: video_same_channel, role: "follower")

      expect(recommendation.with_same_channel).to match_array([video_same_channel])
    end
  end

  describe "#with_same_performance" do
    it "returns videos with same performance" do
      video = videos(:video_1_featured)
      recommendation = described_class.new(video)
      video_same_channel = Video.create!(
        event: video.event,
        channel: video.channel,
        song: video.song,
        youtube_id: "1234",
        upload_date: video.upload_date + 5.days,
        hidden: false,
        title: "unnecessary",
        description: "unnecessary"
      )
      DancerVideo.create!(dancer: video.leaders.first, video: video_same_channel, role: "leader")
      DancerVideo.create!(dancer: video.followers.first, video: video_same_channel, role: "follower")

      expect(recommendation.with_same_performance).to match_array(video_same_channel)
    end
  end
end
