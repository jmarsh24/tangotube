# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongSearchable do
  describe "#search_text" do
    it "returns a string with the title, artist, and genre" do
      song = Song.create!(title: "Milonga del 83", artist: "Juan D'Arienzo", genre: "Milonga")

      expect(song.search_text).to eq("milonga del 83 ochenta y tres juan d arienzo milonga")
    end
  end
end
