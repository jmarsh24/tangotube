# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::PerformanceMatcher do
  describe "#parse" do
    let(:matcher) { described_class.new }

    context "when performance information is present" do
      [
        {text: "Amazing performance 3 of 5 by the great dancers", position: 3, total: 5},
        {text: "Amazing performance 2/7 by the great dancers", position: 2, total: 7},
        {text: "Amazing performance 4 de 8 by the great dancers", position: 4, total: 8},
        {text: "Amazing performance 1-6 by the great dancers", position: 1, total: 6},
        {text: "Amazing performance 5|7 by the great dancers", position: 5, total: 7}
      ].each do |test_data|
        it "returns a Performance struct with position and total for '#{test_data[:text]}'" do
          result = matcher.parse(text: test_data[:text])

          expect(result).to be_a(ExternalVideoImport::MetadataProcessing::PerformanceMatcher::Performance)
          expect(result.position).to eq(test_data[:position])
          expect(result.total).to eq(test_data[:total])
        end
      end
    end

    context "when performance information is not present" do
      it "returns nil" do
        text = "Amazing performance by the great dancers"
        result = matcher.parse(text:)

        expect(result).to be_nil
      end
    end

    context "when performance information is invalid" do
      it "returns nil" do
        text = "Amazing performance 6 of 3 by the great dancers"
        result = matcher.parse(text:)

        expect(result).to be_nil
      end
    end
  end
end
