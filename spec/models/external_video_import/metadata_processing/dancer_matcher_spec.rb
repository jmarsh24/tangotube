# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::DancerMatcher do
  fixtures :all

  describe "#match" do
    subject(:dancer_matcher) { described_class.new(video_title:) }

    context "when there are matching dancers in the video title" do
      let(:video_title) { "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1" }

      it "returns the matched dancers" do
        expect(dancer_matcher.dancers.map(&:name)).to match_array([dancers(:carlitos).name, dancers(:noelia).name])
      end
    end

    context "when there are no matching dancers" do
      let(:video_title) { "Nonexistent Dancer Another Nonexistent Dancer Tango" }

      it "returns an empty array" do
        expect(dancer_matcher.dancers.map(&:name)).to eq([])
      end
    end

    context "with accented characters in video title" do
      let(:video_title) { "Lorena Tarrantino Gianpiero Galdi Tango" }

      it "returns the matched dancers" do
        expect(dancer_matcher.dancers.map(&:name)).to match_array([dancers(:lorena).name, dancers(:gianpiero).name])
      end
    end

    context "when similar but incorrect dancer names are in the video title" do
      let(:video_title) { "Vanesa Villalba and Facundo Pinero - Tu Voz" }

      it "does not include incorrect dancers" do
        expect(dancer_matcher.dancers.map(&:name)).to match_array([dancers(:facundo).name, dancers(:vanessa).name])
        expect(dancer_matcher.dancers.map(&:name)).not_to include(dancers(:facundo_gil).name)
      end
    end

    context "with dancers having similar names" do
      let(:video_title) { "Carlitos Espinoza & Agustina Piaggio - Sobre el Pucho - MSTF 2022 " }
      let!(:augustina_piaggio) { Dancer.create!(name: "Augustina Piaggio", gender: "female") }

      before do
        Dancer.create!(name: "Augustina Paez", gender: "female")
      end

      it "matches only the correct dancers" do
        expect(dancer_matcher.dancers.map(&:name)).to match_array([dancers(:carlitos).name, augustina_piaggio.name])
      end
    end

    context "matching dancers with specific names" do
      let(:video_title) { "CORINA HERRERA & INÉS MUZOPPAPA - RELIQUIAS PORTEÑAS - MUY MARTES TANGO" }
      let(:inez) { dancers(:inez) }

      it "returns the matched dancers" do
        inez.update!(match_terms: ["muzopapa", "muzoppapa"])
        expect(dancer_matcher.dancers.map(&:name)).to match_array([dancers(:corina).name, dancers(:inez).name])
      end
    end

    context "matching dancers with 'majo' and 'pablo' in the title" do
      let(:video_title) { "Pablo Rodriguez y Majo Martirena, 2-5 (Almaty, Kazakhstan)" }

      before do
        Dancer.create!(name: "Pablo Martin")
        Dancer.create!(name: "Majo Martirena")
        Dancer.create!(name: "Pablo Rodriguez")
      end

      it "returns the matched dancers" do
        expect(dancer_matcher.dancers.map(&:name)).to match_array(["Pablo Rodriguez", "Majo Martirena"])
      end
    end
  end
end
