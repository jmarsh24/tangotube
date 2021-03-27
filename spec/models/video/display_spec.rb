require "rails_helper"

RSpec.describe Video::Display do
  describe ".display.any_song_attribute" do
    it "only song exists" do
      song = build(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = build(:video, click_count: 0, song: song)
      display = described_class.new(video)
      expect(display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end

    it "song doesn't exist" do
      video = build(:video)
      display = described_class.new(video)
      expect(display.any_song_attributes).to eq(nil)
    end

    it "only youtube song exists" do
      video = build(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr_cloud exists" do
      video = build(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only spotify exists" do
      video = build(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.any_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.external_song_attributes" do
    it "only spotify exists" do
      video = build(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only youtube exists" do
      video = build(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "only acr cloud exists" do
      video = build(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'agostino")
      display = described_class.new(video)
      expect(display.external_song_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "no song attributes exist" do
      video = build(:video)
      display = described_class.new(video)
      expect(display.external_song_attributes).to eq(nil)
    end
  end

  describe ".display.el_recodo_attributes" do
    it "missing song" do
      video = build(:video, song: nil)
      display = described_class.new(video)
      expect(display.el_recodo_attributes).to eq(nil)
    end

    it "has all attributes" do
      song = build(:song, title: "No Vendrá", artist: "Angel D'AGOSTINO", genre: "TANGO")
      video = build(:video, song: song)
      display = described_class.new(video)
      expect(display.el_recodo_attributes).to eq("No Vendrá - Angel D'Agostino - Tango")
    end
  end

  describe ".display.spotify_attributes" do
    it "has both track_name and artist_name" do
      video = build(:video, spotify_track_name: "No Vendrá", spotify_artist_name: "Angel D'AGOSTINO")
      display = described_class.new(video)
      expect(display.spotify_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing artist_name" do
      video = build(:video, spotify_track_name: "No Vendrá", spotify_artist_name: nil)
      display = described_class.new(video)
      expect(display.spotify_attributes).to eq(nil)
    end

    it "missing track_name" do
      video = build(:video, spotify_artist_name: "Angel D'AGOSTINO", spotify_track_name: nil)
      display = described_class.new(video)
      expect(display.spotify_attributes).to eq(nil)
    end
  end

  describe ".display.youtube_attributes" do
    it "has both youtube_song and youtube_artist" do
      video = build(:video, youtube_song: "No Vendrá", youtube_artist: "Angel D'AGOSTINO")
      display = described_class.new(video)
      expect(display.youtube_attributes).to eq("No Vendrá - Angel D'Agostino")
    end

    it "missing youtube_song" do
      video = build(:video, youtube_artist: "Angel D'AGOSTINO", youtube_song: nil)
      display = described_class.new(video)
      expect(display.youtube_attributes).to eq(nil)
    end

    it "missing artist_name" do
      video = build(:video, youtube_song: "Angel D'AGOSTINO", youtube_artist: nil)
      display = described_class.new(video)
      expect(display.youtube_attributes).to eq(nil)
    end
  end

  describe ".display.acr_cloud_attributes" do
    it "missing acr_cloud_track_name" do
      video = build(:video, acr_cloud_artist_name: "Angel D'AGOSTINO", acr_cloud_track_name: nil)
      display = described_class.new(video)
      expect(display.acr_cloud_attributes).to eq(nil)
    end

    it "missing acr_cloud_artist_name" do
      video = build(:video, acr_cloud_track_name: "Angel D'AGOSTINO", acr_cloud_artist_name: nil)
      display = described_class.new(video)
      expect(display.acr_cloud_attributes).to eq(nil)
    end

    it "has both acr_cloud_track_name and acr_cloud_artist_name" do
      video = build(:video, acr_cloud_track_name: "No Vendrá", acr_cloud_artist_name: "Angel D'AGOSTINO")
      display = described_class.new(video)
      expect(display.acr_cloud_attributes).to eq("No Vendrá - Angel D'Agostino")
    end
  end

  describe ".display.dancer_names" do
    it "missing leader" do
      follower = build(:follower, name: "Noelia Hurtado")
      video = build(:video, leader: nil, follower: follower)
      display = described_class.new(video)
      expect(display.dancer_names).to eq(nil)
    end

    it "missing follower" do
      leader = build(:leader, name: "Carlitos Espinoza")
      video = build(:video, leader: leader, follower: nil)
      display = described_class.new(video)
      expect(display.dancer_names).to eq(nil)
    end

    it "has both leader and follower" do
      leader = build(:leader, name: "Carlitos Espinoza")
      follower = build(:follower, name: "Noelia Hurtado")
      video = build(:video, leader: leader, follower: follower)
      display = described_class.new(video)
      expect(display.dancer_names).to eq("Carlitos Espinoza & Noelia Hurtado")
    end
  end
end
