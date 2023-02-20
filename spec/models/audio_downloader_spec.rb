# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioDownloader do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      audio_filepath = AudioDownloader.download(slug).audio_filepath
      expected_filepath = Rails.root.join("tmp/audio/video_#{slug}/#{slug}.mp3").to_s
      expect(audio_filepath.to_s).to eq expected_filepath
      expect(File.size(audio_filepath)).to eq 2688467
      expect(File.extname(audio_filepath)).to eq ".mp3"
    end
  end
end
