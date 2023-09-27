# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongMatcher do
  fixtures :all

  let(:song) { songs(:nueve_de_julio) }
  let(:song_matcher) { described_class.new }

  describe "#match" do
    context "when the song exists" do
      it "returns a match for Milonga del 83" do
        song = Song.create!(title: "Milonga del 83", artist: "Juan D'ARIENZO", genre: "Milonga", orchestra: orchestras(:darienzo), last_name_search: "darienzo")
        video_title = "Agustina Piaggio &Carlitos Espinoza - Milonga Del 83 - by SivisArt"
        video_description = "Carlitos Espinoza & Agustina Piaggio  at the Baden Baden Tango Festival 2022.\nSubscribe to my channel.\nImages & Realisation: Sivis'Art - ALL RIGHTS RESERVED.\n-Website: http://www.sivisart.com/\n-Instagram: Sivisart\n-facebook: Sivisart\n\nFeel free to comment, like, share the video. Thank you for your support & Enjoy !"
        song_titles = ["Milonga Del Ochenta Y Tres"]
        song_albums = []
        song_artists = ["Juan D'Arienzo y su Orquesta Típica"]
        expect(described_class.new.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(song)
      end

      it "returns a match for Quedemos aqui" do
        orchestra = Orchestra.create!(
          name: "José Basso",
          slug: "jose-basso",
          search_term: "basso"
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

      it "returns the match for ya lo ves" do
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

      it "returns the match for bajo el cono azul" do
        orchestra = Orchestra.create!(
          name: "Alfredo De Angelis",
          slug: "angelis",
          search_term: "angelis"
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

      it "returns the a match for mozo guapo" do
        Orchestra.create!(
          name: "Trío YUMBA",
          slug: "trio-yumba",
          search_term: "trio yumba"
        )

        tanturi = Orchestra.create!(
          name: "Ricardo Tanturi",
          slug: "ricardo-tanturi",
          search_term: "tanturi"
        )

        song_mozo_guapo = Song.create!(
          genre: "TANGO",
          orchestra: tanturi,
          title: "Mozo guapo",
          artist: "Ricardo Tanturi",
          active: true
        )

        video_title = "Mirella and Carlos Santos David - Mozo guapo"
        video_description = "Mirella and Carlos Santos David dance “Mozo guapo“ by Ricardo Tanturi, sung by Alberto Castillo, at Cafe Tango in Wuppertal, Germany.\n\n\r\r\r\rIf you love Tango videos, help us create more on\n\r\rhttps://www.patreon.com/030tango\r\r\n\nVisit 030tango for more videos\n\r\rhttps://www.030tango.com\n\n\r\r\r\rRecorded on 2020/09/0\r4\n#030tango #tango #CarlosEMirella"
        song_titles = ["Mozo Guapo", "Mozo guapo"]
        song_artists = ["Alberto Castillo"]
        expect(song_matcher.match(video_title:, video_description:, song_titles:, song_artists:)).to eq(song_mozo_guapo)
      end

      it "returns a match for milonga vieja milonga" do
        milonga_vieja = Song.create!(
          genre: "MILONGA",
          artist: "Juan D'Arienzo",
          title: "Milonga Vieja Milonga",
          orchestra: orchestras(:darienzo)
        )

        video_title = "Carmencita Calderon y Juan Averna (show 2)  C.I.T.A. 2000"
        video_description = "фрагмент записи на DVD шоу-выступлений C.I.T.A. 2000"
        song_titles = ["Milonga Vieja Milonga (Instrumental)"]
        song_artists = ["Orquesta Alfredo Juan D' Arienzo"]

        expect(song_matcher.match(video_title:, video_description:, song_titles:, song_artists:)).to eq(milonga_vieja)
      end

      it "returns the a match for lo que el viento se llevo" do
        canaro = Orchestra.create!(
          name: "Francisco Canaro",
          slug: "francisco-canaro",
          search_term: "canaro"
        )

        se_llevo = Song.create!(
          genre: "TANGO",
          title: "Lo que el viento se llevó",
          artist: "Francisco CANARO",
          orchestra: canaro
        )

        Song.create!(
          genre: "TANGO",
          title: "Amor",
          artist: "Francisco CANARO",
          orchestra: canaro
        )

        video_title = "Maja Petrović  & Marko Miljević  - \"Lo que el viento se llevo\" - Canaro/Amor"
        video_description = "La Gilda, Brescia, 05.06.2016."
        song_titles = ["Lo Que El Viento Se Llevó", "Lo Que El Viento Se llevo (10974)"]
        song_artists = ["Francisco Canaro", "Fransisco Amor", "Francisco Canaro Y Su Orquesta Tipica"]
        song_albums = ["Glorias Del Tango: Francisco Canaro Vol. 2"]
        expect(song_matcher.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(se_llevo)
      end

      it "returns a match for milonga qu peina canas" do
        darienzo = orchestras(:darienzo)

        que_peina_canas = Song.create!(
          genre: "TANGO",
          title: "Milonga que peina canas",
          artist: "Juan Darienzo",
          orchestra: darienzo
        )

        Song.create!(
          genre: "TANGO",
          title: "Caña",
          artist: "Juan D'ARIENZO",
          orchestra: darienzo
        )

        video_title = "Maja Petrović  & Marko Miljević  - \"Milonga que peina canas\" - D'Arienzo - 4 (Milonga)"
        video_description = "Show in \"Tango O nada\" in Seoul, September 2018."
        song_titles = ["Milonga Que Peina Canas", "Milonga que peina canas"]
        song_artists = ["Juan D'Arienzo y su Orquesta Típica", "Armando Laborde", "Juan d'Arienzo, Armando Laborde"]
        song_albums = ["La puñalada"]
        expect(song_matcher.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(que_peina_canas)
      end

      it "returns a match for Ilusión De Mi Vida" do
        Song.create!(
          genre: "Alternative",
          title: "Тополиный пух",
          artist: "Иванушки International"
        )

        illustion_de_mi_vida_song = Song.create!(
          genre: "Alternative",
          title: "Ilusión De Mi Vida",
          artist: "Ariel Ramírez"
        )

        video_title = "13th Shanghai International Tango Festival Day 2 - Fernando Sanchez y Ariadna Naveira 2"
        video_description = "曲目:Ilusión de mi vida - Ariel Ramírez"
        song_titles = ["Ilusión De Mi Vida", "Ilusión De Mi Vida - Instrumental"]
        song_artists = ["Ariel Ramírez", "Ariel Ramírez"]
        song_albums = ["Acuarela Folklorica"]
        expect(song_matcher.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)).to eq(illustion_de_mi_vida_song)
      end

      it "returns a match for Ilusión De Mi Vida and not russian song" do
        Song.create!(
          genre: "Alternative",
          title: "Тополиный пух",
          artist: "Иванушки International"
        )

        video_title = "13th Shanghai International Tango Festival Day 2 - Fernando Sanchez y Ariadna Naveira 2"
        video_description = "曲目:Ilusión de mi vida - Ariel Ramírez"
        song_titles = ["Ilusión De Mi Vida", "Ilusión De Mi Vida - Instrumental"]
        song_artists = ["Ariel Ramírez", "Ariel Ramírez"]
        song_albums = ["Acuarela Folklorica"]

        song = song_matcher.match(video_title:, video_description:, song_titles:, song_albums:, song_artists:)
        expect(song.artist).to eq "Ariel Ramírez"
        expect(song.genre).to eq "Alternative"
        expect(song.title).to eq "Ilusión De Mi Vida"
      end

      it "returns a match for el chamuyo" do
        calo = Orchestra.create!(
          name: "Miguel Calo",
          slug: "miguel-calo",
          search_term: "calo"
        )

        el_chamuyo = Song.create!(title: "El Chamuyo", artist: "Miguel CALO", orchestra: calo)
        video_title = "Carlitos Espinoza & Agustina Piaggio - Sobre el Pucho - MSTF 2022 #summerembraces"
        video_description = "www.summertango.com"

        expect(song_matcher.match(video_title:, video_description:)).not_to eq(el_chamuyo)
      end
    end
  end
end
