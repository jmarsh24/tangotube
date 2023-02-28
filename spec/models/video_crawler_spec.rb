# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoCrawler do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "crawl" do
    before :each do
      allow(YoutubeScraper).to receive(:metadata).and_return(["Cuando El Amor Muere", "Carlos Di Sarli y su Orquesta Típica"])
      allow(YoutubeAudioDownloader).to receive(:with_download_file).and_return(file_fixture("audio.mp3"))
      allow(MusicRecognizer).to receive(:process_audio_snippet).and_return(
        {cost_time: 0.60599994659424,
         metadata: {music: [{label: "UMG - Universal Music Argentina S.A.",
                             title: "La Mentirosa",
                             album: {name: "Cantan Alberto Morán Y Roberto Chanel"},
                             score: 100,
                             artists: [{langs: [{name: "オスバルド・プグリエーセ", code: "ja-Jpan"},
                               {name: "オスバルドプグリエーセ", code: "ja-Hrkt"}],
                                        name: "Osvaldo Pugliese"},
                               {langs: [{name: "アルベルト・モラン", code: "ja-Jpan"},
                                 {name: "アルベルトモラン", code: "ja-Hrkt"}],
                                name: "Alberto Moran"}],
                             acrid: "0d07891de1a0b282efce9b20dfce2bba",
                             external_ids: {isrc: "ARF040200415"},
                             external_metadata: {youtube: {vid: "9Yj-xPNOMo8"},
                                                 spotify: {track: {id: "0iAj9eP9ZjNw7QcvjRoxgO", name: "La Mentirosa"},
                                                           artists: [{name: "Osvaldo Pugliese"}, {name: "Alberto Moran"}],
                                                           album: {name: "Canta garganta con arena"}}},
                             result_from: 3,
                             genres: [{name: "Tango"}, {name: "World"}],
                             release_date: "2020-04-08",
                             duration_ms: 195000,
                             db_begin_time_offset_ms: 109060,
                             db_end_time_offset_ms: 119840,
                             sample_begin_time_offset_ms: 0,
                             sample_end_time_offset_ms: 10780,
                             play_offset_ms: 121000}],
                    timestamp_utc: "2023-02-19 14:07:17"},
         status: {msg: "Success", code: 0, version: "1.0"},
         result_type: 0}
      )
      @data = VideoCrawler.new.crawl(slug)
    end

    it "returns the video data from youtube", vcr: {preserve_exact_body_bytes: true} do
      data = @data.dig(:youtube)
      expect(data.dig(:slug)).to eq "AQ9Ri3kWa_4"
      expect(data.dig(:title)).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(data.dig(:description)).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(data.dig(:upload_date)).to eq "2014-10-26 15:21:29 UTC"
      expect(data.dig(:duration)).to eq 167
      expect(data.dig(:tags)).to eq ["Amsterdam", "Netherlands", "tango", "argentinian tango", "milonga", "noelia hurtado", "carlitos espinoza", "carlos espinoza", "espinoza", "hurtado", "noelia", "hurtado espinoza", "Salon de los Sabados", "Academia de Tango", "Nederland"]
      expect(data.dig(:hd)).to eq true
      expect(data.dig(:view_count)).to eq 1044
      expect(data.dig(:favorite_count)).to eq 0
      expect(data.dig(:like_count)).to eq 3
      expect(data.dig(:youtube_music)).to eq ["Cuando El Amor Muere", "Carlos Di Sarli y su Orquesta Típica"]
    end

    it "returns the video data from acr cloud", vcr: {preserve_exact_body_bytes: true} do
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
