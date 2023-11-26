# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::MetadataProcessing::DancerMatcher do
  fixtures :all

  describe "#match" do
    let(:dancer_matcher) { described_class.new }

    context "when there are matching dancers in the video title" do
      it "returns the matched dancers" do
        video_title = "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"

        expect(dancer_matcher.match(video_title:)).to match_array([dancers(:carlitos), dancers(:noelia)])
      end
    end

    context "when there are no matching dancers" do
      it "returns an empty array" do
        video_title = "Nonexistent Dancer Another Nonexistent Dancer Tango"

        expect(dancer_matcher.match(video_title:)).to eq([])
      end
    end

    context "with accented characters in video title" do
      it "returns the matched dancers" do
        video_title = "Lorena Tarrantino Gianpiero Galdi Tango"
        gianpierro = dancers(:gianpiero)
        gianpierro.update!(match_terms: ["gianpiero galdi"])

        expect(dancer_matcher.match(video_title:)).to match_array([dancers(:lorena), dancers(:gianpiero)])
      end
    end

    context "when similar but incorrect dancer names are in the video title" do
      it "does not include incorrect dancers" do
        video_title = "Vanesa Villalba and Facundo Pinero - Tu Voz"

        expect(dancer_matcher.match(video_title:)).to match_array([dancers(:facundo), dancers(:vanessa)])
        expect(dancer_matcher.match(video_title:)).not_to include(dancers(:facundo_gil))
      end
    end

    context "with dancers having similar names" do
      it "matches only the correct dancers" do
        video_title = "Carlitos Espinoza & Agustina Piaggio - Sobre el Pucho - MSTF 2022 "
        augustina_piaggio = Dancer.create!(name: "Augustina Piaggio", gender: "female")
        Dancer.create!(name: "Agustina Paez", gender: "female")

        expect(dancer_matcher.match(video_title:)).to match_array([dancers(:carlitos), augustina_piaggio])
      end
    end

    context "matching dancers with specific names" do
      it "returns the matched dancers" do
        video_title = "CORINA HERRERA & INÉS MUZOPPAPA - RELIQUIAS PORTEÑAS - MUY MARTES TANGO"
        inez_muzzopappa = dancers(:inez)
        inez_muzzopappa.update!(match_terms: ["muzopapa", "muzoppapa"])

        expect(dancer_matcher.match(video_title:)).to match_array([dancers(:corina), inez_muzzopappa])
      end
    end

    context "matching dancers with 'majo' and 'pablo' in the title" do
      it "returns the matched dancers" do
        Dancer.create!(name: "Pablo Martin", use_trigram: false)
        majo_martirena = Dancer.create!(name: "Majo Martirena")
        pablo_rodriguez = Dancer.create!(name: "Pablo Rodriguez")
        video_title = "Pablo Rodriguez y Majo Martirena, 2-5 (Almaty, Kazakhstan)"

        expect(dancer_matcher.match(video_title:)).to match_array([pablo_rodriguez, majo_martirena])
      end
    end

    it "matches michael nadtochi" do
      michael_nadotchi = Dancer.create!(name: "Michael Nadtochi", match_terms: ["micheal nadtochi"])
      video_title = 'Corazón de Oro (Francisco Canaro) - Micheal "El Gato" Nadtochi & Elvira Lambo'

      expect(dancer_matcher.match(video_title:)).to match_array([michael_nadotchi])
    end

    it "matches carlitos and noelia" do
      video_title = "Carlitos & Noelia Tango #2 (2016 August)"
      augustina_piaggio = Dancer.create!(name: "Augustina Piaggio", gender: "female", match_terms: ["Carlitos Augustina", "Carlito Augustina"])
      carlitos = dancers(:carlitos)
      noelia = dancers(:noelia)

      carlitos.update!(match_terms: ["Carlitos Augustina", "Carlito Augustina", "carlitos noelia"])
      noelia.update!(match_terms: ["carlitos noelia"])
      expect(dancer_matcher.match(video_title:)).to match_array([carlitos, noelia])
      expect(dancer_matcher.match(video_title:)).not_to include(augustina_piaggio)
    end

    xit "doesn't match gavito" do
      video_title = "Marcela Duran & Carlos Barrionuevo at Gavito Tango Festival 1/3"
      marcela_duran = Dancer.create!(name: "Marcela Duran")
      carlos_barrionuevo = Dancer.create!(name: "Carlos Barrionuevo")
      carlos_gavito = Dancer.create!(name: "Carlos Gavito")
      matched_dancers = dancer_matcher.match(video_title:)

      expect(matched_dancers).to eq([marcela_duran, carlos_barrionuevo])
      expect(matched_dancers).not_to include(carlos_gavito)
    end
  end
end
