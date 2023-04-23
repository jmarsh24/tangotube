# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }
  let(:trimmed_audio) { file_fixture("audio_snippet.mp3").open }
  let(:audio_file) { file_fixture("audio.mp3").open }
  let(:acr_cloud_response) { JSON.parse file_fixture("acr_cloud_response.json").read, symbolize_names: true }
  let(:acr_cloud) { MusicRecognizer::AcrCloud.new }
  let(:audio_trimmer) { MusicRecognizer::AudioTrimmer.new }
  let(:youtube_audio_downloader) { MusicRecognizer::YoutubeAudioDownloader.new }

  describe "process_audio_snippet" do
    it "returns the music data from ACR Cloud and Spotify" do
      allow_any_instance_of(MusicRecognizer::AcrCloud).to receive(:analyze).and_return MusicRecognizer::MusicRecognitionMetadata.new(code: 0)
      allow_any_instance_of(MusicRecognizer::AudioTrimmer).to receive(:trim).and_yield trimmed_audio
      allow_any_instance_of(MusicRecognizer::YoutubeAudioDownloader).to receive(:download_file).and_yield audio_file

      metadata = MusicRecognizer.new.process_audio_snippet(slug)

      expect(metadata.code).to eq 0
    end
  end
end
