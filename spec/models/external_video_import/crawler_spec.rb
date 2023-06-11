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

    let(:youtube_scraper) do
      metadata = ExternalVideoImport::Youtube::VideoMetadata.new(slug)
      youtube_scraper = ExternalVideoImport::Youtube::Scraper.new
      allow(youtube_scraper).to receive(:video_metadata).and_return metadata
      youtube_scraper
    end

    it "returns the video data from youtube" do
      video_crawler = ExternalVideoImport::Crawler.new(youtube_scraper:, music_recognizer:)

      metadata = video_crawler.metadata(slug)
      expect(metadata.youtube.slug).to eq "AQ9Ri3kWa_4"
      expect(metadata.music.acr_id).to eq "a8d9899317fd427b6741b739de8ded15"
    end
  end
end
