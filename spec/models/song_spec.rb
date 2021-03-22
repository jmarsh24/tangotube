require "rails_helper"

RSpec.describe Song, type: :model do
  let(:song) { build(:song) }
  let(:video) { build(:video) }

  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:artist) }

  it { is_expected.to have_many(:videos) }
  it { is_expected.to have_many(:leader).through(:videos) }
  it { is_expected.to have_many(:follower).through(:videos) }

  it { is_expected.to belong_to(:video).counter_cache(true) }

  describe ".sort_by_popularity" do
    it "order songs in database in descending order" do
      song = create(:song, popularity: 100)
      song2 = create(:song, popularity: 99)
      expect(described_class.sort_by_popularity.first).to eq(song)
    end
  end

  describe ".filter_by_active" do
    it "order songs in database in descending order" do
      song = create(:song, active: true)
      expect(described_class.filter_by_active).to include(song)
    end
  end

  describe ".filter_by_not_active" do
    it "order songs in database in descending order" do
      song = create(:song, active: false)
      expect(described_class.filter_by_not_active).to include(song)
    end
  end

  describe ".title_match" do
    it "find song by title" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("No Vendrá")
      expect(@result).to include(song)
    end

    it "find song by title with partial prefix" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("No Ven")
      expect(@result).to include(song)
    end

    it "find song by title with partial suffix" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("endrá")
      expect(@result).to include(song)
    end

    it "find song by title with partial middle match" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("vend")
      expect(@result).to include(song)
    end

    it "find song by title without accent" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("No Vendra")
      expect(@result).to include(song)
    end

    it "find song by title without titleize" do
      song = create(:song, title: "No Vendrá")
      @result = described_class.title_match("no vendrá")
      expect(@result).to include(song)
    end
  end

  describe ".full_title_search" do
    it "find song with artist" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("angel d'agostino")
      expect(@result).to include(song)
    end

    it "find song with partial artist" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("agostino")
      expect(@result).to include(song)
    end

    it "find song with genre" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("tango")
      expect(@result).to include(song)
    end

    it "find song with partial genre" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("ango")
      expect(@result).to include(song)
    end

    it "find song with title" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("no vendra")
      expect(@result).to include(song)
    end

    it "find song with partial title" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      @result = described_class.full_title_search("endra")
      expect(@result).to include(song)
    end
  end

  describe ".full_title" do
    it "find song return string with 'title - artist - genre'" do
      song = create(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      expect(song.full_title).to eq("No Vendrá - Angel D'Agostino - Tango")
    end

    it "titleizes artist names without ' properly" do
      song = create(:song, title: "Tal vez será su voz", artist: "Anibal Troilo", genre: "TANGO")
      expect(song.full_title).to eq("Tal Vez Será Su Voz - Anibal Troilo - Tango")
    end
  end

  describe ".set_all_popularity_values" do
    it "calculates popularity values" do
      song = create(:song)
      channel = create(:channel)
      create(:video, channel: channel, song: song)
      create(:video, channel: channel, song: song)
      create(:video, channel: channel, song: song)
      song.reload
      described_class.set_all_popularity_values
      expect(song.popularity).to eq(100)
    end
  end
end
