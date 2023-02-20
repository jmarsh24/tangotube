# frozen_string_literal: true

require "rails_helper"

RSpec.describe Youtube do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "fetch" do
    it "returns the video data from youtube", :vcr do
      video_data = Youtube.fetch(slug:).metadata
      expect(video_data.as_json).to eq JSON.parse file_fixture("youtube_response.json").read
    end

    it "returns a thumbnail", :vcr do
      expect(File.exist?(Youtube.fetch(slug:).thumbnail)).to be true
      expect(File.size(Youtube.fetch(slug:).thumbnail)).to be 76935
    end
  end
end
