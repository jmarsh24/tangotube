# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoCrawler do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "crawl" do
    it "returns the video data from youtube and acrcloud", vcr: {preserve_exact_body_bytes: true} do
      video_data = VideoCrawler.crawl(slug).metadata
      expect(video_data.as_json).to eq JSON.parse file_fixture("video_crawler_response.json").read
    end
  end
end
