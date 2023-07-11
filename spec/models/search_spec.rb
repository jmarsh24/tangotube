# frozen_string_literal: true

require "rails_helper"

RSpec.describe Search, type: :model do
  fixtures :all

  describe "#results" do
    it "returns an array of results" do
      channel = channels(:"030tango")
      search = Search.new(term: "030")

      expect(search.results["Channel"].first).to eq(channel)
    end
  end
end
