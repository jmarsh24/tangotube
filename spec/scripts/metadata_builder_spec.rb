# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scripts::MetadataBuilder do
  fixtures :all

  describe ".build_metadata" do
    let(:video) { videos(:video_1_featured) }

    subject { described_class.build_metadata(video) }

    it "creates a Metadata object with Youtube metadata" do
      expect(subject.youtube).to be_a(ExternalVideoImport::Youtube::VideoMetadata)
      expect(subject.youtube.title).to eq(video.title)
      # ... add other assertions for Youtube metadata fields
    end

    it "creates a Metadata object with Song metadata" do
      expect(subject.youtube.song).to be_a(ExternalVideoImport::Youtube::SongMetadata)
      expect(subject.youtube.song.titles).to include(video.youtube_song)
      # ... add other assertions for Song metadata fields
    end

    it "creates a Metadata object with Music Recognition metadata" do
      expect(subject.music).to be_a(ExternalVideoImport::MusicRecognition::Metadata)
      expect(subject.music.acr_song_title).to eq(video.acr_cloud_track_name)
      # ... add other assertions for Music Recognition metadata fields
    end
  end
end
