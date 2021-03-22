# == Schema Information
#
# Table name: videos_searches
#
#  video_id     :bigint           primary key
#  tsv_document :tsvector
#
require "rails_helper"

RSpec.describe VideosSearch, type: :model do
  describe ".refresh" do
    it "materialized view able to be refreshed" do
      video = create(:video)
      VideosSearch.refresh
      expect(VideosSearch.count).to eq(1)
    end
  end

  describe ".search" do
    it "materialized view is searchable" do
      video = create(:video)
      VideosSearch.refresh
      expect(VideosSearch.count).to include(1)
    end
  end
end
