# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::MetadataProcessor do
  fixtures :all

  subject(:metadata_processor) do
    described_class.new
  end

  describe "#process" do
    let(:couple) { couples(:carlitos_noelia) }

    it "processes the metadata and returns the video attributes" do
      attributes = metadata_processor.process(metadata)

      expect(attributes[:youtube_id]).to eq("test_video_slug")
      expect(attributes[:upload_date]).to eq("2022-01-01".to_date)
      expect(attributes[:upload_date_year]).to eq(2022)
      expect(attributes[:song]).to eq(song_metadata)
      expect(attributes[:couples]).to eq([couple])
    end

    context "when couple is nil" do
      before do
        allow(couple_matcher).to receive(:match_or_create).and_return(nil)
      end

      it "returns nil for the couples attribute" do
        attributes = metadata_processor.process(metadata)

        expect(attributes[:couple]).to be_nil
      end
    end

    context "when dancers are an empty array and couple is nil" do
      before do
        allow(dancer_matcher).to receive(:match).with(video_title: youtube_metadata.title).and_return([])
        allow(couple_matcher).to receive(:match_or_create).and_return(nil)
      end

      it "returns nil for the couples attribute" do
        attributes = metadata_processor.process(metadata)

        expect(attributes[:dancers]).to be_nil
        expect(attributes[:couple]).to be_nil
      end
    end
  end
end
