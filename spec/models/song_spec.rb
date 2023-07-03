# frozen_string_literal: true

# == Schema Information
#
# Table name: songs
#
#  id                :bigint           not null, primary key
#  genre             :string
#  title             :string
#  artist            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  artist_2          :string
#  composer          :string
#  author            :string
#  date              :date
#  last_name_search  :string
#  occur_count       :integer          default(0)
#  popularity        :integer          default(0)
#  active            :boolean          default(TRUE)
#  lyrics            :text
#  el_recodo_song_id :integer
#  videos_count      :integer          default(0), not null
#  lyrics_en         :string
#  slug              :string
#  orchestra_id      :bigint
#  display_title     :string
#  spotify_track_id  :string
#
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
