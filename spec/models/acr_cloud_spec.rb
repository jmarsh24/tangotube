# frozen_string_literal: true

require "rails_helper"

RSpec.describe AcrCloud do
  fixtures :all

  let(:audio_file) { file_fixture("blank_audio.mp3").open }

  describe "analyze" do
    it "sends a request to ACR Cloud" do
      stub_request(:post, "http://identify-eu-west-1.acrcloud.com/v1/identify")
        .and_return(status: 200, body: file_fixture("acr_cloud_response.json").read)

      data = AcrCloud.new.analyze audio_file

      status = data.dig :status
      metadata = data.dig :metadata
      music = metadata.dig(:music)[0]
      expect(status.dig(:code)).to eq 0
      expect(status.dig(:msg)).to eq "Success"
      expect(music.dig(:title)).to eq "Cuando El Amor Muere"
      expect(music.dig(:album, :name)).to eq "Serie 78 RPM : Carlos Di Sarli Vol.2"
      expect(music.dig(:acrid)).to eq "a8d9899317fd427b6741b739de8ded15"
      expect(music.dig(:external_ids, :isrc)).to eq "ARF034100046"
      expect(music.dig(:artists, 0, :name)).to eq "Carlos Di Sarli y su Orquesta Típica"
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
