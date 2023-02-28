# frozen_string_literal: true

require "rails_helper"

RSpec.describe AcrCloud do
  fixtures :all

  let(:audio_file) { file_fixture("audio.mp3") }

describe "send" do
    it "send a request to ACR Cloud", vcr: {preserve_exact_body_bytes: true} do
      @data = AcrCloud.new.upload(audio_file)
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
