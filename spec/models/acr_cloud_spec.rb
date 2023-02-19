# frozen_string_literal: true

require "rails_helper"

RSpec.describe AcrCloud do
  fixtures :all

  let(:sound_file) { file_fixture("audio.mp3") }

  describe "send" do
    it "send a request to ACR Cloud" do
      AcrCloud.send(sound_file:).data
    end
  end
end
