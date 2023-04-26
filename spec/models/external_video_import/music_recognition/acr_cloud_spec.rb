# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MusicRecognition::AcrCloud do
  fixtures :all

  let(:audio_file) { file_fixture("blank_audio.mp3").open }

  describe "#analyze" do
    it "sends a request to ACR Cloud" do
      stub_request(:post, "http://identify-eu-west-1.acrcloud.com/v1/identify")
        .and_return(status: 200, body: file_fixture("acr_cloud_response.json").read)

      metadata = ExternalVideoImport::MusicRecognition::AcrCloud.new.analyze file: audio_file
      expect(metadata.code).to eq 0
      expect(metadata.message).to eq "Success"
      expect(metadata.acr_song_title).to eq "Cuando El Amor Muere"
      expect(metadata.acr_album_name).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(metadata.acr_id).to eq "a8d9899317fd427b6741b739de8ded15"
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
