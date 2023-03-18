# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }
  let(:trimmed_audio) { file_fixture("audio_snippet.mp3").open }
  let(:audio_file) { file_fixture("audio.mp3").open }
  let(:acr_cloud_response) { JSON.parse file_fixture("acr_cloud_response.json").read, symbolize_names: true }
  let(:acr_cloud) { AcrCloud.new }
  let(:audio_trimmer) { AudioTrimmer.new }
  let(:youtube_audio_downloader) { YoutubeAudioDownloader.new }

  describe "process_audio_snippet" do
    it "returns the music data from ACR Cloud and Spotify" do
      allow(acr_cloud).to receive(:analyze).and_return acr_cloud_response
      allow(audio_trimmer).to receive(:trim).and_yield trimmed_audio
      allow(youtube_audio_downloader).to receive(:download_file).and_yield audio_file

      music_recognizer = MusicRecognizer.new(acr_cloud:, audio_trimmer:, youtube_audio_downloader:)

      metadata = music_recognizer.process_audio_snippet(slug)

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
