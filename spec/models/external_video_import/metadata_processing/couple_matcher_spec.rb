# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::CoupleMatcher do
  fixtures :dancers, :couples

  describe "#match_or_create" do
    let(:couple_matcher) { described_class.new }

    it "returns an existing couple when matched dancers are provided" do
      dancers = [dancers(:carlitos), dancers(:noelia)]
      expect(couple_matcher.match_or_create(dancers:)).to eq(couples(:carlitos_noelia))
    end

    fit "creates a new couple when unmatched dancers are provided" do
      dancers = [dancers(:unreviewed_dancer), dancers(:corina)]

      new_couple = couple_matcher.match_or_create(dancers:)

      expect(new_couple).to be_a(Couple)
      expect(new_couple.dancer).to eq(dancers.first)
      expect(new_couple.partner).to eq(dancers.second)
    end

    it "returns nil when more or less than 2 dancers are provided" do
      dancers = [dancers(:carlitos)]
      expect(couple_matcher.match_or_create(dancers)).to be_nil

      dancers = [dancers(:carlitos), dancers(:noelia), dancers(:jonathan)]
      expect(couple_matcher.match_or_create(dancers)).to be_nil
    end
  end
end
