# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::MetadataProcessing::CoupleMatcher do
  fixtures :all

  describe "#match_or_create" do
    let(:couple_matcher) { described_class.new }

    it "returns an array of existing or newly created couples for matched dancers" do
      dancers = [dancers(:carlitos), dancers(:noelia)]
      existing_couple = couples(:carlitos_noelia)

      result = couple_matcher.match_or_create(dancers:)

      expect(result).to eq existing_couple
    end

    it "creates new couples when unmatched dancers are provided" do
      dancers = [dancers(:corina), dancers(:unreviewed_dancer)]

      result = couple_matcher.match_or_create(dancers:)

      matched_dancers = [result.dancer, result.partner]

      expect(matched_dancers).to include(dancers(:unreviewed_dancer))
      expect(matched_dancers).to include(dancers(:corina))
    end

    it "returns an empty array when more than 2 dancers are provided" do
      dancers = [dancers(:carlitos), dancers(:noelia), dancers(:jonathan)]
      result = couple_matcher.match_or_create(dancers:)
      expect(result).to be_nil
    end
  end
end