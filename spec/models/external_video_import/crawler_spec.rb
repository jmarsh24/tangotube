# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Crawler do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "#metadata" do
    let(:music_recognizer) do
      music_metadata = ExternalVideoImport::MusicRecognition::Metadata.new(acr_id: "a8d9899317fd427b6741b739de8ded15")
      music_recognizer = ExternalVideoImport::MusicRecognition::MusicRecognizer.new
      allow(music_recognizer).to receive(:process_audio_snippet).and_return music_metadata
      music_recognizer
    end

    let(:metadata_provider) do
      metadata = ExternalVideoImport::Youtube::VideoMetadata.new(slug:)
      metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new
      allow(metadata_provider).to receive(:video_metadata).and_return metadata
      metadata_provider
    end

    it "returns the video data from youtube" do
      video_crawler = ExternalVideoImport::Crawler.new(metadata_provider:, music_recognizer:)

      metadata = video_crawler.metadata(slug, use_scraper: true, use_music_recognizer: true)
      expect(metadata.youtube.slug).to eq "AQ9Ri3kWa_4"
      expect(metadata.music.acr_id).to eq "a8d9899317fd427b6741b739de8ded15"
    end

    it "returns the video data from youtube without music recognition" do
      video_crawler = ExternalVideoImport::Crawler.new(metadata_provider:, music_recognizer:)

      metadata = video_crawler.metadata(slug, use_scraper: true, use_music_recognizer: false)
      expect(metadata.youtube.slug).to eq "AQ9Ri3kWa_4"
      expect(metadata.music).to be_a(ExternalVideoImport::MusicRecognition::Metadata)
      expect(metadata.music.code).to be_nil
    end
  end
end
