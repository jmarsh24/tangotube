# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioDownloader do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      file = file_fixture("audio.mp3").open
      AudioDownloader.new.with_download_file(slug) do |downloaded_file|
        expect(downloaded_file.read).to eq file.read
      end
      expect(File.exist?("/tmp/audio/video_#{slug}/#{slug}.mp3")).to be false
    end
  end
end
