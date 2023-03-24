# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoCrawler do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "#video_metadata" do
    before :each do
      song = SongMetadata.new(
        titles: ["Cuando El Amor Muere"],
        artist: "Carlos Di Sarli y su Orquesta Típica",
        album: nil
      )

      thumbnail_url =
        ThumbnailUrl.new(
          default: "https://i.ytimg.com/vi/AQ9Ri3kWa_4/default.jpg",
          medium: "https://i.ytimg.com/vi/AQ9Ri3kWa_4/mqdefault.jpg",
          high: "https://i.ytimg.com/vi/AQ9Ri3kWa_4/hqdefault.jpg",
          standard: "https://i.ytimg.com/vi/AQ9Ri3kWa_4/sddefault.jpg",
          maxres: "https://i.ytimg.com/vi/AQ9Ri3kWa_4/maxresdefault.jpg"
        )

      channel_metadata = ChannelMetadata.new

      video_metadata = YoutubeVideoMetadata.new(
        slug: "AQ9Ri3kWa_4",
        channel_slug: "UCvnY4F-CJVgYdQuIv8sqp-A",
        title: "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1",
        description:
          "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango",
        upload_date: "2014-10-26 15:21:29 UTC",
        duration: 167,
        tags:
          ["Amsterdam",
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
            "Nederland"],
        hd: true,
        view_count: 1046,
        favorite_count: 0,
        comment_count: 0,
        like_count: 3,
        song:,
        thumbnail_url:,
        recommended_video_ids: ["p0AQ3gx3eo8", "p0AQ3gx3eo8", "p0AQ3gx3eo8"]
      )

      music_metadata = MusicRecognitionMetadata.new(
        code: 0,
        message: "Success",
        acr_song_title: "Cuando El Amor Muere",
        acr_artist_names: ["Carlos Di Sarli y su Orquesta Típica"],
        acr_album_name: "Serie 78 RPM : Carlos Di Sarli Vol.2",
        acrid: "a8d9899317fd427b6741b739de8ded15",
        isrc: "ARF034100046",
        genre: "Tango",
        spotify_artist_names: ["Carlos Acuña", "Carlos Di Sarli"],
        spotify_track_name: "Cuando El Amor Muere",
        spotify_track_id: "66jpnblQkPOngiFwEEyUW3",
        spotify_album_name: "Serie 78 RPM : Carlos Di Sarli Vol.2",
        spotify_album_id: nil,
        youtube_vid: "p0AQ3gx3eo8"
      )

      youtube_scraper = YoutubeScraper.new
      allow(youtube_scraper).to receive(:video_metadata).and_return video_metadata
      music_recognizer = MusicRecognizer.new
      allow(music_recognizer).to receive(:process_audio_snippet).and_return music_metadata

      video_crawler = VideoCrawler.new(youtube_scraper:, music_recognizer:)
      @metadata = video_crawler.video_metadata(slug)
    end

    it "returns the video data from youtube" do
      metadata = @metadata.youtube
      expect(metadata.slug).to eq "AQ9Ri3kWa_4"
      expect(metadata.channel_slug).to eq "UCvnY4F-CJVgYdQuIv8sqp-A"
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.duration).to eq 167
      expect(metadata.tags).to eq ["Amsterdam", "Netherlands", "tango", "argentinian tango", "milonga", "noelia hurtado", "carlitos espinoza", "carlos espinoza", "espinoza", "hurtado", "noelia", "hurtado espinoza", "Salon de los Sabados", "Academia de Tango", "Nederland"]
      expect(metadata.hd).to eq true
      expect(metadata.view_count).to eq 1046
      expect(metadata.favorite_count).to eq 0
      expect(metadata.like_count).to eq 3
      expect(metadata.thumbnail_url.default).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/default.jpg"
      expect(metadata.thumbnail_url.medium).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/mqdefault.jpg"
      expect(metadata.thumbnail_url.high).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/hqdefault.jpg"
      expect(metadata.thumbnail_url.standard).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/sddefault.jpg"
      expect(metadata.thumbnail_url.maxres).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/maxresdefault.jpg"
      expect(metadata.song.titles).to eq ["Cuando El Amor Muere"]
      expect(metadata.song.artist).to eq "Carlos Di Sarli y su Orquesta Típica"
      expect(metadata.recommended_video_ids).to eq ["p0AQ3gx3eo8", "p0AQ3gx3eo8", "p0AQ3gx3eo8"]
    end

    it "returns the video data from acr cloud" do
      metadata = @metadata.acr_cloud
      expect(metadata.code).to eq 0
      expect(metadata.message).to eq "Success"
      expect(metadata.acr_song_title).to eq "Cuando El Amor Muere"
      expect(metadata.acr_album_name).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(metadata.acrid).to eq "a8d9899317fd427b6741b739de8ded15"
      expect(metadata.isrc).to eq "ARF034100046"
      expect(metadata.acr_artist_names).to eq ["Carlos Di Sarli y su Orquesta Típica"]
      expect(metadata.acr_album_name).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(metadata.genre).to eq "Tango"
      expect(metadata.spotify_artist_names).to eq ["Carlos Acuña", "Carlos Di Sarli"]
      expect(metadata.spotify_track_name).to eq "Cuando El Amor Muere"
      expect(metadata.spotify_track_id).to eq "66jpnblQkPOngiFwEEyUW3"
      expect(metadata.spotify_album_id).to eq nil
      expect(metadata.youtube_vid).to eq "p0AQ3gx3eo8"
    end
  end
end
