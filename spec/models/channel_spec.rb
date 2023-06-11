# frozen_string_literal: true

require "rails_helper"

RSpec.describe Channel do
  fixtures :all

  describe "#update_from_youtube", :vcr do
    it "updates the channel with the latest metadata from YouTube" do
      channel = channels(:"030tango")
      channel.update!(title: "old title")

      channel.update_from_youtube!

      expect(channel.title).to eq("030tango")
    end

    it "destroys the channel if it doesn't exist on YouTube" do
      channel = channels(:"030tango")
      channel.update!(channel_id: "invalid")

      channel.update_from_youtube!

      expect(channel).to be_destroyed
    end
  end
end
