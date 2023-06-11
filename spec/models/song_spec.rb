# frozen_string_literal: true

require "rails_helper"

RSpec.describe Song do
  fixtures :all

  describe "#full_title" do
    it "returns correct title when all attributes are present" do
      song = songs(:nueve_de_julio)
      expect(song.full_title).to eq("Nueve De Julio - Juan D'Arienzo - Tango")
    end

    it "returns correct title with artist if genre is blank" do
      song = songs(:nueve_de_julio)
      song.update!(genre: nil)
      expect(song.full_title).to eq("Nueve De Julio - Juan D'Arienzo")
    end
  end
end
