# frozen_string_literal: true

RSpec.describe VideoSearch do
  fixtures :all

  describe "#search" do
    it "finds results" do
      videos = [videos(:video_1_featured), videos(:video_4_featured)]

      expect(VideoSearch.search("carlitos espinoza")).to eq []

      VideoSearch.refresh

      results = VideoSearch.search("carlitos espinoza")
      expect(results).to match_array(videos.map(&:id))
    end
  end
end
