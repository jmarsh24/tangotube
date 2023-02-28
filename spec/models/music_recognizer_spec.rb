# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "recognize" do
    xit "returns the music data from ACR Cloud and Spotify", vcr: {preserve_exact_body_bytes: true} do
      # allow(AudioDownloader).to receive(:filepath).and_return(file_fixture("audio.mp3").to_path)
      # allow(AudioProcessor).to receive(:filepath).and_return(file_fixture("audio_snippet.mp3").to_path)
      @data = MusicRecognizer.new.process_audio_snippet(slug)
      status = @data.dig :acrcloud, :status
      data = @data.dig :acrcloud, :metadata
      music = data.dig(:music)[0]
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
      expect(File.exist?("/tmp/audio/video_#{slug}/#{slug}_snippet.mp3")).to be false
    end
  end
end
