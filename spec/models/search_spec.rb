# frozen_string_literal: true

require "rails_helper"

RSpec.describe Search, type: :model do
  fixtures :all

  describe "#results" do
    it "returns an array of results" do
      skip "Waiting for videosearch to be refactored"
      channel = channels(:"030tango")
      search = Search.new(query: "030")

      expect(search.results.first.type).to eq("channels")
      expect(search.results.first.record).to eq(channel)
    end
  end
end
