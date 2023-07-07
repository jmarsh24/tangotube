# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongMatcher do
  fixtures :all

  let(:song) { songs(:nueve_de_julio) }
  let(:accented_song) { songs(:cafe_dominguez) }
  let(:song_matcher) { described_class.new }

  describe "#match" do
    context "when the song exists" do
      it "returns the best match" do
        song = Song.create!(title: "Milonga del 83", artist: "Juan D'ARIENZO", genre: "Milonga", orchestra: orchestras(:darienzo), last_name_search: "darienzo")
        video_title = "Agustina Piaggio &Carlitos Espinoza - Milonga Del 83 - by SivisArt"
        video_description = "Carlitos Espinoza & Agustina Piaggio  at the Baden Baden Tango Festival 2022.\nSubscribe to my channel.\nImages & Realisation: Sivis'Art - ALL RIGHTS RESERVED.\n-Website: http://www.sivisart.com/\n-Instagram: Sivisart\n-facebook: Sivisart\n\nFeel free to comment, like, share the video. Thank you for your support & Enjoy !"
        song_titles = ["Milonga Del Ochenta Y Tres"]
        song_albums = []
        song_artists = ["Juan D'Arienzo y su Orquesta Típica"]
        expect(described_class.new.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(song)
      end

      it "returns the best match" do
        orchestra = Orchestra.create!(
          name: "José Basso",
          slug: "jose-basso",
          search_term: "jose basso"
        )
        song_recondandote = Song.create!(
          genre: "TANGO",
          artist: "José BASSO",
          orchestra:,
          title: "Recordándote",
          active: true
        )

        song_quedemos_aqui = Song.create!(
          genre: "TANGO",
          artist: "José BASSO",
          orchestra:,
          title: "Quedémonos aquí",
          active: true
        )

        song_matcher = described_class.new

        video_title = "Noelia Hurtado and Gaston Torelli - Quedémonos aquí"
        video_description = "Noelia Hurtado and Gaston Torelli dance “Quedémonos aquí” by José Basso, sung by Floreal Ruíz, at the Berlin New Year's Marathon in Berlin, Germany.\n\nIf you love Tango videos, help us create more on\nhttp://www.patreon.com/030tango\n\nVisit 030tango at\nhttp://www.030tango.com\n\nRecorded on 2016/01/02\n#030tango #tango"
        song_titles = ["Quedémonos Aquí"]
        video_tags = ["Tango", "Tango Argentino", "Tango (Music)", "Dance", "030tango", "Noelia Hurtado", "Gaston Torelli", "José Basso", "Floreal Ruíz", "Quedémonos aquí"]
        song_artists = ["Homero Expósito"]
        song_albums = []
        expect(song_matcher.match(video_title:, video_description:, video_tags:, song_titles:, song_albums:, song_artists:)).to eq(song_quedemos_aqui)
        expect(song_matcher.match(video_title:, video_description:, video_tags:, song_titles:, song_albums:, song_artists:)).not_to eq(song_recondandote)
      end

      it "returns the best match" do
        song_ya_lo_ves = Song.create!(
          genre: "TANGO",
          orchestra: orchestras(:darienzo),
          title: "Ya lo ves",
          artist: "Juan D'ARIENZO",
          active: true
        )

        song_matcher = described_class.new

        video_title = "Agustina Piaggio &Carlitos Espinoza - Ya lo vez - D'Arienzo Maure by Sivis'Art"
        video_description = "Carlitos Espinoza & Agustina Piaggio  at the Baden Baden Tango Festival 2022.\nSubscribe to my channel.\nImages & Realisation: Sivis'Art - ALL RIGHTS RESERVED.\n-Website: http://www.sivisart.com/\n-Instagram: Sivisart\n-facebook: Sivisart\n\nFeel free to comment, like, share the video. Thank you for your support & Enjoy !"
        video_tags = ["tango", "trip", "road trip", "tango festival", "tango argentin", "argentine tango", "vlog", "filmmaking", "france", "europe", "travel", "voyage", "music", "milonga", "dance", "kizumba", "salsa", "latina", "buenos aires"]

        expect(song_matcher.match(video_title:, video_description:, video_tags:)).to eq(song_ya_lo_ves)
      end

      it "returns the best match" do
        orchestra = Orchestra.create!(
          name: "Alfredo De Angelis",
          slug: "angelis",
          search_term: "alfredo de angelis"
        )
        song_bajo_el_cono_azul = Song.create!(
          genre: "TANGO",
          orchestra:,
          title: "Bajo El Cono Azul",
          artist: "Alfredo De Angelis",
          active: true
        )

        video_title = "Carlitos Espinoza and Noelia Hurtado performance 1 @ All Night Milonga NYC June 25, 2016"
        video_description = "Carlitos Espinoza and Noelia Hurtado performance 1 @ All Night Milonga NYC June 25, 2016"
        video_tags = ["Carlitos Espinoza and Noelia Hurtado performance 1 @ All Night Milonga NYC June 25", "2016"]
        song_titles = ["Bajo El Cono Azul (Remasterizada)", "Bajo El Cono Azul (Remasterizada)"]
        song_albums = ["100 Tangos Inmortales (Remasterizado)", "100 Tangos Inmortales (Remasterizado)"]
        song_artists = ["Alfredo De Angelis", "Alfredo De Angelis"]

        expect(song_matcher.match(video_title:, video_description:, video_tags:, song_titles:, song_albums:, song_artists:)).to eq(song_bajo_el_cono_azul)
      end
    end
  end
end
