# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "recognize" do
    it "returns the music data from ACR Cloud and Spotify", vcr: {preserve_exact_body_bytes: true} do
      allow(AudioTrimmer).to receive(:trim).and_return(file_fixture("audio_snippet.mp3").open)
      allow(YoutubeAudioDownloader).to receive(:with_download_file).and_return(file_fixture("audio.mp3").open)
      @data = MusicRecognizer.new.process_audio_snippet(slug)
      status = @data.dig :status
      metadata = @data.dig :metadata
      music = metadata.dig(:music)[0]
      expect(status.dig(:code)).to eq 0
      expect(status.dig(:msg)).to eq "Success"
      expect(music.dig(:title)).to eq "La Mentirosa"
      expect(music.dig(:album, :name)).to eq "Cantan Alberto Morán Y Roberto Chanel"
      expect(music.dig(:acrid)).to eq "0d07891de1a0b282efce9b20dfce2bba"
      expect(music.dig(:external_ids, :isrc)).to eq "ARF040200415"
      expect(music.dig(:artists, 0, :name)).to eq "Osvaldo Pugliese"
      expect(music.dig(:artists, 1, :name)).to eq "Alberto Moran"
      expect(music.dig(:album, :name)).to eq "Cantan Alberto Morán Y Roberto Chanel"
      expect(music.dig(:genres, 0, :name)).to eq "Tango"
      expect(music.dig(:external_metadata, :spotify, :artists, 0, :name)).to eq "Osvaldo Pugliese"
      expect(music.dig(:external_metadata, :spotify, :artists, 1, :name)).to eq "Alberto Moran"
      expect(music.dig(:external_metadata, :spotify, :track, :name)).to eq "La Mentirosa"
      expect(music.dig(:external_metadata, :spotify, :track, :id)).to eq "0iAj9eP9ZjNw7QcvjRoxgO"
      expect(music.dig(:external_metadata, :spotify, :album, :name)).to eq "Canta garganta con arena"
      expect(music.dig(:external_metadata, :youtube, :vid)).to eq "9Yj-xPNOMo8"
    end
  end
end
