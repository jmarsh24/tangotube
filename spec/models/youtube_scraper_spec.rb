# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeScraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "scrape" do
    it "returns song artist and title if present", :vcr do
      data = YoutubeScraper.scrape(slug).data
      expect(data).to eq ["Cuando El Amor Muere", "Carlos Di Sarli y su Orquesta Típica"]
    end
  end
end
