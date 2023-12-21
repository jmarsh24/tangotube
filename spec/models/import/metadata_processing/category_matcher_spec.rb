# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::MetadataProcessing::CategoryMatcher do
  describe "#category" do
    context "when title matches interview keywords" do
      it "returns interview" do
        matcher = Import::MetadataProcessing::CategoryMatcher.new(video_title: "Entrevista con un maestro", dancer_count: 0)
        expect(matcher.category).to eq("interview")
      end
    end

    context "when title matches class keywords" do
      it "returns class" do
        matcher = Import::MetadataProcessing::CategoryMatcher.new(video_title: "Tango Class Highlights", dancer_count: 0)
        expect(matcher.category).to eq("class")
      end
    end

    context "when title matches workshop keywords" do
      it "returns workshop" do
        matcher = Import::MetadataProcessing::CategoryMatcher.new(video_title: "Exclusive Workshop", dancer_count: 0)
        expect(matcher.category).to eq("workshop")
      end
    end

    context "when title does not match any keyword and has sufficient dancer count" do
      it "returns performance" do
        matcher = Import::MetadataProcessing::CategoryMatcher.new(video_title: "Random Tango Video", dancer_count: 2)
        expect(matcher.category).to eq("performance")
      end
    end

    context "when title does not match any keyword and has insufficient dancer count" do
      it "returns nil" do
        matcher = Import::MetadataProcessing::CategoryMatcher.new(video_title: "Random Tango Video", dancer_count: 1)
        expect(matcher.category).to be_nil
      end
    end
  end
end
