# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongMatcher do
  fixtures :all

  let(:song) { songs(:nueve_de_julio) }
  let(:accented_song) { songs(:cafe_dominguez) }
  let(:song_matcher) { described_class.new }

  describe "#match" do
    context "when the song exists" do
      fit "returns the best match" do
        song = Song.create!(title: "Milonga del 83", artist: "Juan D'ARIENZO", genre: "Milonga", orchestra: orchestras(:darienzo), last_name_search: "ARIENZO")
        video_title = "Agustina Piaggio &Carlitos Espinoza - Milonga Del 83 - by SivisArt"
        video_description = "Carlitos Espinoza & Agustina Piaggio  at the Baden Baden Tango Festival 2022.\nSubscribe to my channel.\nImages & Realisation: Sivis'Art - ALL RIGHTS RESERVED.\n-Website: http://www.sivisart.com/\n-Instagram: Sivisart\n-facebook: Sivisart\n\nFeel free to comment, like, share the video. Thank you for your support & Enjoy !"
        song_titles = ["Milonga Del Ochenta Y Tres"]
        song_albums = []
        song_artists = ["Juan D'Arienzo y su Orquesta Típica"]
        expect(described_class.new.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(song)
      end
    end
  end
end
