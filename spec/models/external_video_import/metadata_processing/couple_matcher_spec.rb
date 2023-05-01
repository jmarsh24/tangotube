# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::CoupleMatcher do
  fixtures :all

  describe "#match_or_create" do
    let(:couple_matcher) { described_class.new }

    it "returns an array of existing or newly created couples for matched dancers" do
      dancers = [dancers(:carlitos), dancers(:noelia)]
      existing_couple = couples(:carlitos_noelia)

      result = couple_matcher.match_or_create(dancers: dancers)

      expect(result).to contain_exactly(existing_couple)
    end

    it "creates new couples when unmatched dancers are provided" do
      dancers = [dancers(:unreviewed_dancer), dancers(:corina)]

      result = couple_matcher.match_or_create(dancers: dancers)

      expect(result).to all(be_a(Couple))
      expect(result.size).to eq(1)
      expect(result.first.dancer).to eq(dancers.first)
      expect(result.first.partner).to eq(dancers.second)
    end

    it "returns an empty array when more than 2 dancers are provided" do
      dancers = [dancers(:carlitos), dancers(:noelia), dancers(:jonathan)]
      result = couple_matcher.match_or_create(dancers: dancers)
      expect(result).to eq([])
    end
  end
end
