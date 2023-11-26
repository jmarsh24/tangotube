# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::MusicRecognition::MusicRecognizer do
  fixtures :all

  let(:slug) { videos(:video_1_featured).youtube_id }
  let(:trimmed_audio) { file_fixture("audio_snippet.mp3").open }
  let(:audio_file) { file_fixture("audio.mp3").open }
  let(:acr_cloud_response) { JSON.parse file_fixture("acr_cloud_response.json").read, symbolize_names: true }

  describe "process_audio_snippet" do
    let(:acr_cloud) do
      acr_cloud = Import::MusicRecognition::AcrCloud.new
      allow(acr_cloud).to receive(:analyze).and_return Import::MusicRecognition::Metadata.new code: 0
      acr_cloud
    end

    let(:audio_trimmer) do
      audio_trimmer = Import::MusicRecognition::AudioTrimmer.new
      allow(audio_trimmer).to receive(:trim).and_yield trimmed_audio
      audio_trimmer
    end

    let(:youtube_audio_downloader) do
      youtube_audio_downloader = Import::MusicRecognition::YoutubeAudioDownloader.new
      allow(youtube_audio_downloader).to receive(:download_file).and_yield audio_file
      youtube_audio_downloader
    end

    it "returns the music data from ACR Cloud and Spotify" do
      metadata = described_class.new(acr_cloud:, audio_trimmer:, youtube_audio_downloader:).process_audio_snippet(slug)

      expect(metadata.code).to eq 0
    end
  end
end
