# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeScraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "fetch" do
    it "returns the video metadata from youtube" do
      stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&part=snippet")
        .with(
          headers: {
            "Content-Length" => "0",
            "User-Agent" => "Yt::Request (gzip)"
          }
        ).to_return(status: 200, body: file_fixture("youtube_scraper_response.json").read, headers: {})

      stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=contentDetails")
        .with(
          headers: {
            "Content-Length" => "0",
            "User-Agent" => "Yt::Request (gzip)"
          }
        ).to_return(status: 200, body: file_fixture("youtube_scraper_response_1.json").read, headers: {})

      stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=statistics")
        .with(
          headers: {
            "Content-Length" => "0",
            "User-Agent" => "Yt::Request (gzip)"
          }
        ).to_return(status: 200, body: file_fixture("youtube_scraper_response_2.json").read, headers: {})

      youtube_scraper = YoutubeScraper.new
      allow(youtube_scraper).to receive(:song).and_return(SongMetadata.new(title: "Cuando El Amor Muere", artist: "Carlos Di Sarli y su Orquesta Típica"))
      metadata = youtube_scraper.video_metadata(slug)

      expect(metadata.slug).to eq slug
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.tags).to match_array [
        "Amsterdam",
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
        "Nederland"
      ]
      expect(metadata.duration).to eq 167
      expect(metadata.hd).to eq true
      expect(metadata.view_count).to eq 1046
      expect(metadata.favorite_count).to eq 0
      expect(metadata.comment_count).to eq 0
      expect(metadata.like_count).to eq 3
      expect(metadata.song.title).to eq "Cuando El Amor Muere"
      expect(metadata.song.artist).to eq "Carlos Di Sarli y su Orquesta Típica"
    end
  end
end
