# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::DancerMatcher do
  fixtures :all

  describe "#match" do
    let(:dancer_matcher) { described_class.new }

    context "when there are matching dancers in the video title" do
      it "returns the matched dancers" do
        video_title = "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array([dancers(:carlitos).name, dancers(:noelia).name])
      end
    end

    context "when there are no matching dancers" do
      it "returns an empty array" do
        video_title = "Nonexistent Dancer Another Nonexistent Dancer Tango"
        expect(dancer_matcher.match(video_title:).map(&:name)).to eq([])
      end
    end

    context "with accented characters in video title" do
      it "returns the matched dancers" do
        video_title = "Lorena Tarrantino Gianpiero Galdi Tango"
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array([dancers(:lorena).name, dancers(:gianpiero).name])
      end
    end

    context "when similar but incorrect dancer names are in the video title" do
      it "does not include incorrect dancers" do
        video_title = "Vanesa Villalba and Facundo Pinero - Tu Voz"
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array([dancers(:facundo).name, dancers(:vanessa).name])
        expect(dancer_matcher.match(video_title:).map(&:name)).not_to include(dancers(:facundo_gil).name)
      end
    end

    context "with dancers having similar names" do
      it "matches only the correct dancers" do
        video_title = "Carlitos Espinoza & Agustina Piaggio - Sobre el Pucho - MSTF 2022 "
        augustina_piaggio = Dancer.create!(name: "Augustina Piaggio", gender: "female")
        Dancer.create!(name: "Agustina Paez", gender: "female")
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array([dancers(:carlitos).name, augustina_piaggio.name])
      end
    end

    context "matching dancers with specific names" do
      it "returns the matched dancers" do
        video_title = "CORINA HERRERA & INÉS MUZOPPAPA - RELIQUIAS PORTEÑAS - MUY MARTES TANGO"
        inez_muzzopappa = dancers(:inez)
        inez_muzzopappa.update!(match_terms: ["muzopapa", "muzoppapa"])
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array([dancers(:corina).name, inez_muzzopappa.name])
      end
    end

    context "matching dancers with 'majo' and 'pablo' in the title" do
      it "returns the matched dancers" do
        Dancer.create!(name: "Pablo Martin")
        Dancer.create!(name: "Majo Martirena")
        Dancer.create!(name: "Pablo Rodriguez")
        video_title = "Pablo Rodriguez y Majo Martirena, 2-5 (Almaty, Kazakhstan)"
        expect(dancer_matcher.match(video_title:).map(&:name)).to match_array(["Pablo Rodriguez", "Majo Martirena"])
      end
    end
  end
end
