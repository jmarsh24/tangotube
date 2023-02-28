# frozen_string_literal: true

require "rails_helper"

RSpec.describe Youtube do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "fetch" do
    it "returns the video data from youtube", :vcr do
      allow(YoutubeScraper).to receive(:metadata).and_return(["Cuando El Amor Muere", "Carlos Di Sarli y su Orquesta Típica"])

      metadata = Youtube.new(slug).metadata
      expect(metadata.dig(:slug)).to eq slug
      expect(metadata.dig(:title)).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.dig(:description)).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.dig(:upload_date)).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.dig(:duration)).to eq 167
      expect(metadata.dig(:tags)).to eq ["Amsterdam",
        "Netherlands",
        "tango",
        "argentinian tango",
        "milonga",
        "noelia hurtado",
        "carlitos espinoza",
        "carlos espinoza",
        "espinoza",
        "hurtado",
        "noelia",
        "hurtado espinoza",
        "Salon de los Sabados",
        "Academia de Tango",
        "Nederland"]
      expect(metadata.dig(:hd)).to eq true
      expect(metadata.dig(:view_count)).to eq 1044
      expect(metadata.dig(:favorite_count)).to eq 0
      expect(metadata.dig(:comment_count)).to eq 0
      expect(metadata.dig(:like_count)).to eq 3
      expect(metadata.dig(:youtube_music, 0)).to eq "Cuando El Amor Muere"
      expect(metadata.dig(:youtube_music, 1)).to eq "Carlos Di Sarli y su Orquesta Típica"
    end

    it "returns a thumbnail", :vcr do
      Youtube.new(slug).thumbnail do |thumbnail|
        expect(thumbnail.size).to eq 76935
      end
    end
  end
end
