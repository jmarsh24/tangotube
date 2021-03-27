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
#
require "rails_helper"

RSpec.describe Song, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:genre) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:artist) }
  end

  describe "associations" do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:leader).through(:videos) }
    it { is_expected.to have_many(:follower).through(:videos) }
  end

  describe "scope" do
    describe ".sort_by_popularity" do
      it "order songs in database in descending order" do
        popular_song = create(:song, popularity: 100)
        less_popular_song = create(:song, popularity: 99)
        expect(described_class.sort_by_popularity).to eq([popular_song, less_popular_song])
      end
    end

    describe ".filter_by_active" do
      it "returns active songs" do
        active_song = create(:song, active: true)
        not_active_song = create(:song, active: false)
        expect(described_class.filter_by_active).to eq [active_song]
        expect(described_class.filter_by_active).not_to include(not_active_song)
      end
    end

    describe ".filter_by_not_active" do
      it "returns not active songs" do
        active_song = create(:song, active: true)
        not_active_song = create(:song, active: false)
        expect(described_class.filter_by_active).to eq [active_song]
        expect(described_class.filter_by_not_active).to include(not_active_song)
      end
    end

    describe ".title_match" do
      it "find song by title" do
        match_song = create(:song, title: "No Vendrá")
        no_match_song = create(:song, title: "Not matching song")
        expect(described_class.title_match("no vendra")).to include(match_song)
        expect(described_class.title_match("no vendra")).not_to include(no_match_song)
        expect(described_class.title_match("No Ven")).to include(match_song)
        expect(described_class.title_match("No Ven")).not_to include(no_match_song)
        expect(described_class.title_match("endra")).to include(match_song)
        expect(described_class.title_match("endra")).not_to include(no_match_song)
        expect(described_class.title_match("vend")).to include(match_song)
        expect(described_class.title_match("vend")).not_to include(no_match_song)
        expect(described_class.title_match("No Vendra")).to include(match_song)
        expect(described_class.title_match("No Vendra")).not_to include(no_match_song)
        expect(described_class.title_match("no vendra")).to include(match_song)
        expect(described_class.title_match("no vendra")).not_to include(no_match_song)
      end
    end
  end

  describe "#full_title" do
    it "find song return string with 'title - artist - genre'" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      not_match_song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      expect(song.full_title).to eq("No Vendrá - Angel D'Agostino - Tango")
    end

    it "titleizes artist names with apostrophe properly" do
      song = create(:song, title: "Tal vez será su voz", artist: "Anibal Troilo", genre: "TANGO")
      expect(song.full_title).to eq("Tal Vez Será Su Voz - Anibal Troilo - Tango")
    end
  end

  describe ".full_title_search" do
    it "find song with artist" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      no_match_song = create(:song, title: "Not matching song")
      expect(described_class.full_title_search("angel d'agostino")).to include(song)
      expect(described_class.full_title_search("angel d'agostino")).not_to include(no_match_song)
      expect(described_class.full_title_search("agostino")).to include(song)
      expect(described_class.full_title_search("agostino")).not_to include(no_match_song)
      expect(described_class.full_title_search("tango")).to include(song)
      expect(described_class.full_title_search("tango")).not_to include(no_match_song)
      expect(described_class.full_title_search("ango")).to include(song)
      expect(described_class.full_title_search("ango")).not_to include(no_match_song)
      expect(described_class.full_title_search("no vendra")).to include(song)
      expect(described_class.full_title_search("no vendra")).not_to include(no_match_song)
      expect(described_class.full_title_search("endra")).to include(song)
      expect(described_class.full_title_search("endra")).not_to include(no_match_song)
      expect(described_class.full_title_search("agostino vendra")).to include(song)
      expect(described_class.full_title_search("agostino vendra")).not_to include(no_match_song)
      expect(described_class.full_title_search("dagostino")).to include(song)
      expect(described_class.full_title_search("dagostino")).not_to include(no_match_song)
    end
  end
end
