# frozen_string_literal: true

require "rails_helper"

RSpec.describe HdDataDisplayable, type: :module do
  let(:metadata) do
    ExternalVideoImport::Metadata.new(
      {
        youtube: {
          duration: 180,
          hd: true
        }
      }
    )
  end

  let(:video) do
    instance_double("Video", metadata:)
  end

  let(:presenter) do
    VideoPresenter.new(video)
  end

  describe "#hd_duration_data" do
    context "when metadata has a duration and is HD" do
      it "returns a string formatted as 'HD MM:SS'" do
        expect(presenter.hd_duration_data).to eq("HD 03:00")
      end
    end

    context "when metadata has a duration and is not HD" do
      before do
        metadata[:youtube][:hd] = false
      end

      it "returns a string formatted as 'MM:SS'" do
        expect(presenter.hd_duration_data).to eq("03:00")
      end
    end

    context "when metadata does not have a duration" do
      before do
        metadata[:youtube][:duration] = nil
      end

      it "returns nil" do
        expect(presenter.hd_duration_data).to be_nil
      end
    end
  end
end
