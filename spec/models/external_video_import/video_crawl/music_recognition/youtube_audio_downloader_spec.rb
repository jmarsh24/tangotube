# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::VideoCrawl::MusicRecognition::YoutubeAudioDownloader do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }
  let(:audio_file) { file_fixture("blank_audio.mp3") }

  describe "#download_file" do
    it "returns the video data from youtube and acrcloud" do
      ExternalVideoImport::VideoCrawl::MusicRecognition::YoutubeAudioDownloader.new.download_file(slug:) do |downloaded_file|
        expect(downloaded_file.read).to eq audio_file.read
      end
    end
  end
end
