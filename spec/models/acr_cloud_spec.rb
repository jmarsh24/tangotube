# frozen_string_literal: true

require "rails_helper"

RSpec.describe AcrCloud do
  fixtures :all

  let(:audio_file) { file_fixture("audio.mp3") }

  describe "send" do
    it "send a request to ACR Cloud", vcr: {preserve_exact_body_bytes: true} do
      sound_data = AcrCloud.send(audio_file:).data
      expected_response = JSON.parse file_fixture("acr_cloud_response.json").read, symbolize_names: true
      expect(sound_data).to eq expected_response
    end
  end
end
