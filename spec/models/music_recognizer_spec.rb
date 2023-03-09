# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "process_audio_snippet" do
    it "returns the music data from ACR Cloud and Spotify" do
      acr_cloud = AcrCloud.new
      allow(acr_cloud).to receive(:analyze).and_return JSON.parse file_fixture("acr_cloud_response.json").read, symbolize_names: true

      audio_trimmer = AudioTrimmer.new
      trimmed_audio_file = Tempfile.new
      trimmed_audio_file.binmode
      trimmed_audio_file.write file_fixture("audio_snippet.mp3").read
      allow(audio_trimmer).to receive(:trim).and_return trimmed_audio_file

      youtube_audio_downloader = YoutubeAudioDownloader.new
      audio_file = Tempfile.new
      audio_file.binmode
      audio_file.write file_fixture("audio_snippet.mp3").read
      allow(youtube_audio_downloader).to receive(:download_file).and_return audio_file

      music_recognizer = MusicRecognizer.new(acr_cloud:, audio_trimmer:, youtube_audio_downloader:)

      expect(File.exist?(trimmed_audio_file.path)).to be true
      expect(File.exist?(audio_file.path)).to be true

      metadata = music_recognizer.process_audio_snippet(slug)

      expect(trimmed_audio_file.path).to be nil
      expect(audio_file.path).to be nil

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
