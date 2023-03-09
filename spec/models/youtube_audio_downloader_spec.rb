# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeAudioDownloader do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "#download_file" do
    it "returns the video data from youtube and acrcloud" do
      audio_file = Tempfile.new
      audio_file.binmode
      audio_file.write file_fixture("blank_audio.mp3").read
      audio_file.rewind

      downloaded_file = YoutubeAudioDownloader.new.download_file(slug)
      expect(downloaded_file.read).to eq audio_file.read
    end
  end
end
