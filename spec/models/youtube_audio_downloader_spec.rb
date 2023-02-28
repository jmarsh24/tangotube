# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeAudioDownloader do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "download" do
    it "returns the video data from youtube and acrcloud", :vcr do
      file = file_fixture("audio.mp3").open
      YoutubeAudioDownloader.new.with_download_file(slug) do |downloaded_file|
        expect(downloaded_file.read).to eq file.read
      end
    end
  end
end
