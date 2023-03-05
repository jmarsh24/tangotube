# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoCrawler do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "crawl" do
    before :each do
      # allow(MusicRecognizer).to receive(:process_audio_snippet).and_return(
      #   {cost_time: 0.60599994659424,
      #    metadata: {music: [{label: "UMG - Universal Music Argentina S.A.",
      #                        title: "La Mentirosa",
      #                        album: {name: "Cantan Alberto Morán Y Roberto Chanel"},
      #                        score: 100,
      #                        artists: [{langs: [{name: "オスバルド・プグリエーセ", code: "ja-Jpan"},
      #                          {name: "オスバルドプグリエーセ", code: "ja-Hrkt"}],
      #                                   name: "Osvaldo Pugliese"},
      #                          {langs: [{name: "アルベルト・モラン", code: "ja-Jpan"},
      #                            {name: "アルベルトモラン", code: "ja-Hrkt"}],
      #                           name: "Alberto Moran"}],
      #                        acrid: "0d07891de1a0b282efce9b20dfce2bba",
      #                        external_ids: {isrc: "ARF040200415"},
      #                        external_metadata: {youtube: {vid: "9Yj-xPNOMo8"},
      #                                            spotify: {track: {id: "0iAj9eP9ZjNw7QcvjRoxgO", name: "La Mentirosa"},
      #                                                      artists: [{name: "Osvaldo Pugliese"}, {name: "Alberto Moran"}],
      #                                                      album: {name: "Canta garganta con arena"}}},
      #                        result_from: 3,
      #                        genres: [{name: "Tango"}, {name: "World"}],
      #                        release_date: "2020-04-08",
      #                        duration_ms: 195000,
      #                        db_begin_time_offset_ms: 109060,
      #                        db_end_time_offset_ms: 119840,
      #                        sample_begin_time_offset_ms: 0,
      #                        sample_end_time_offset_ms: 10780,
      #                        play_offset_ms: 121000}],
      #               timestamp_utc: "2023-02-19 14:07:17"},
      #    status: {msg: "Success", code: 0, version: "1.0"},
      #    result_type: 0}
      # )

      song = SongMetadata.new(
        title: "Cuando El Amor Muere",
        artist: "Carlos Di Sarli y su Orquesta Típica",
        album: nil
      )

      video_metadata = YoutubeVideoMetadata.new(
        slug: "AQ9Ri3kWa_4",
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
        thumbnail_urls:
          ["https://i.ytimg.com/vi/AQ9Ri3kWa_4/hq720.jpg",
            "https://i.ytimg.com/vi/AQ9Ri3kWa_4/hqdefault.jpg"]
      )
      youtube_scraper = YoutubeScraper.new
      music_recognizer = MusicRecognizer.new
      allow(youtube_scraper).to receive(:video_metadata).and_return(video_metadata)

      video_crawler = VideoCrawler.new(youtube_scraper:, music_recognizer:)
      @metadata = video_crawler.call(slug)
    end

    it "returns the video data from youtube" do
      metadata = @metadata.dig(:youtube)
      expect(metadata.slug).to eq "AQ9Ri3kWa_4"
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.duration).to eq 167
      expect(metadata.tags).to eq ["Amsterdam", "Netherlands", "tango", "argentinian tango", "milonga", "noelia hurtado", "carlitos espinoza", "carlos espinoza", "espinoza", "hurtado", "noelia", "hurtado espinoza", "Salon de los Sabados", "Academia de Tango", "Nederland"]
      expect(metadata.hd).to eq true
      expect(metadata.view_count).to eq 1046
      expect(metadata.favorite_count).to eq 0
      expect(metadata.like_count).to eq 3
      expect(metadata.song.title).to eq "Cuando El Amor Muere"
      expect(metadata.song.artist).to eq "Carlos Di Sarli y su Orquesta Típica"
    end

    xit "returns the video data from acr cloud", :vcr do
      status = @data.dig :acrcloud, :status
      metadata = @data.dig :acrcloud, :metadata
      music = metadata.dig(:music)[0]
      expect(status.dig(:code)).to eq 0
      expect(status.dig(:msg)).to eq "Success"
      expect(music.dig(:title)).to eq "Cuando El Amor Muere"
      expect(music.dig(:album, :name)).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(music.dig(:acrid)).to eq "a8d9899317fd427b6741b739de8ded15"
      expect(music.dig(:external_ids, :isrc)).to eq "ARF034100046"
      expect(music.dig(:artists, 0, :name)).to eq "Carlos Di Sarli y su Orquesta Típica"
      expect(music.dig(:album, :name)).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(music.dig(:genres, 0, :name)).to eq "Tango"
      expect(music.dig(:external_metadata, :spotify, :artists, 0, :name)).to eq "Carlos Acuña"
      expect(music.dig(:external_metadata, :spotify, :artists, 1, :name)).to eq "Carlos Di Sarli"
      expect(music.dig(:external_metadata, :spotify, :track, :name)).to eq "Cuando El Amor Muere"
      expect(music.dig(:external_metadata, :spotify, :track, :id)).to eq "66jpnblQkPOngiFwEEyUW3"
      expect(music.dig(:external_metadata, :spotify, :album, :name)).to eq "Classics (1940-1943)"
      expect(music.dig(:external_metadata, :youtube, :vid)).to eq "p0AQ3gx3eo8"
    end
  end
end
