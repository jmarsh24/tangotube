# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioTrimmer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      allow(YoutubeAudioDownloader).to receive(:download).and_return(file_fixture("audio.mp3"))
      AudioTrimmer.new.trim(slug) do |trimmed_file|
        expect(trimmed_file.read).to eq file_fixture("audio_snippet.mp3").read
        expect(trimmed_file).to be_a Tempfile
        expect(File.size(trimmed_file)).to eq 320926
        expect(File.extname(trimmed_file)).to eq ".mp3"
      end
    end
  end
end
