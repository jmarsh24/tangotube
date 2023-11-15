# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::MetadataProcessor do
  fixtures :all

  subject(:metadata_processor) do
    described_class.new
  end

  let(:couple) { couples(:carlitos_noelia) }
  let(:song_metadata) do
    ExternalVideoImport::Youtube::SongMetadata.new(
      titles: ["Test Song Title"],
      song_url: "https://open.spotify.com/track/1234567890",
      artist: "Test Song Artist",
      artist_url: "https://open.spotify.com/artist/1234567890",
      writers: ["Test Song Writer"],
      album: "Test Song Album"
    )
  end
  let(:channel_metadata) do
    ExternalVideoImport::Youtube::ChannelMetadata.new(
      id: "UCvnY4F-CJVgYdQuIv8sqp-A",
      title: "Test Channel Title",
      thumbnail_url: "https://i.ytimg.com/vi/test_channel_slug/hqdefault.jpg"
    )
  end
  let(:thumbnail_url) do
    ExternalVideoImport::Youtube::ThumbnailUrl.new(
      default: "https://i.ytimg.com/vi/test_video_slug/default.jpg",
      medium: "https://i.ytimg.com/vi/test_video_slug/mqdefault.jpg",
      high: "https://i.ytimg.com/vi/test_video_slug/hqdefault.jpg",
      standard: "https://i.ytimg.com/vi/test_video_slug/sddefault.jpg",
      maxres: "https://i.ytimg.com/vi/test_video_slug/maxresdefault.jpg"
    )
  end
  let(:youtube_metadata) do
    ExternalVideoImport::Youtube::VideoMetadata.new(
      slug: "AQ9Ri3kWa_4",
      title: "carlitos espinoza and noelia hurtado",
      description: "Test Video Description",
      upload_date: "2022-01-01".to_date,
      duration: 100,
      tags: ["test", "video", "tags"],
      hd: true,
      view_count: 100,
      favorite_count: 100,
      comment_count: 100,
      like_count: 100,
      song: song_metadata,
      thumbnail_url: "https://i.ytimg.com/vi/test_video_slug/hqdefault.jpg",
      recommended_video_ids: ["test_video_slug_1", "test_video_slug_2"],
      channel: channel_metadata,
      blocked: false
    )
  end
  let(:music_metadata) do
    ExternalVideoImport::MusicRecognition::Metadata.new
  end
  let(:metadata) do
    ExternalVideoImport::Metadata.new(
      youtube: youtube_metadata,
      music: music_metadata
    )
  end

  describe "#process" do
    it "processes the metadata and returns the video attributes" do
      attributes = metadata_processor.process(metadata)

      expect(attributes[:youtube_id]).to eq("AQ9Ri3kWa_4")
      expect(attributes[:upload_date]).to eq("2022-01-01".to_date)
      expect(attributes[:upload_date_year]).to eq(2022)
      expect(attributes[:song].title).to eq("Test Song Title")
      expect(attributes[:couple_videos].first.couple_id).to eq(couple.id)
    end
  end
end
