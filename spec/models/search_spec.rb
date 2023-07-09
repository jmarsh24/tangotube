# frozen_string_literal: true

require "rails_helper"

RSpec.describe Search, type: :model do
  fixtures :all

  describe "#results" do
    it "returns an array of results" do
      channel = channels(:"030tango")
      search = Search.new("030")
      expect(search.results).to be_an(Array)
      expect(search.results.first).to be_a(Channel)
      expect(search.results.first).to eq(channel)
    end
  end
end
