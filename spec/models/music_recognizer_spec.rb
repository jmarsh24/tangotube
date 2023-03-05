# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "recognize" do
    it "returns the music data from ACR Cloud and Spotify", :vcr do
      acr_cloud = AcrCloud.new
      allow(acr_cloud).to receive(:upload).and_return(file_fixture("acr_cloud_response.json").read)
      audio_file = file_fixture("audio_snippet.mp3").open
      music_recognizer = MusicRecognizer.new(acr_cloud:, audio_file:)

      metadata = music_recognizer.process_audio_snippet(slug)

      expect(metadata.status).to eq 0
      expect(metadata.message).to eq "Success"
      expect(metadata.acr_title).to eq "La Mentirosa"
      expect(metadata.acr_album_name).to eq "Cantan Alberto Morán Y Roberto Chanel"
      expect(metadata.acrid).to eq "0d07891de1a0b282efce9b20dfce2bba"
      expect(metadata.isrc).to eq "ARF040200415"
      expect(metadata.acr_artist_name).to eq ["Osvaldo Pugliese", "Alberto Moran"]
      expect(metadata.acr_album_name).to eq "Cantan Alberto Morán Y Roberto Chanel"
      expect(metadata.genre).to eq "Tango"
      expect(metadata.spotify_artist_name).to eq ["Osvaldo Pugliese", "Alberto Moran"]
      expect(metadata.spotify_track_name).to eq "La Mentirosa"
      expect(metadata.spotify_track_id).to eq "0iAj9eP9ZjNw7QcvjRoxgO"
      expect(metadata.spotify_album_id).to eq "Canta garganta con arena"
      expect(metadata.youtube_vid).to eq "9Yj-xPNOMo8"
    end
  end
end
