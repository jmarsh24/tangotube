# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::ThumbnailAttacher do
  let(:object) { double("Object", thumbnail: double("Thumbnail")) }
  let(:thumbnail_url) { "https://example.com/thumbnail.jpg" }

  describe "#attach_thumbnail" do
    context "when thumbnail URL is not blank" do
      it "attaches the thumbnail to the object" do
        allow(object).to receive(:class).and_return(Object)

        tempfile = Tempfile.new(["thumbnail", ".jpg"])
        expect(Tempfile).to receive(:open).and_yield(tempfile)

        expect(Down).to receive(:download).with(thumbnail_url, destination: anything).and_return(true)
        expect(object.thumbnail).to receive(:attach).with(
          io: tempfile,
          filename: "object_#{thumbnail_url}.jpg"
        )

        described_class.new.attach_thumbnail(object, thumbnail_url)
      end
    end

    context "when thumbnail URL is blank" do
      it "does not attach the thumbnail to the object" do
        expect(Down).not_to receive(:download)
        expect(object.thumbnail).not_to receive(:attach)

        described_class.new.attach_thumbnail(object, "")
      end
    end

    context "when an error occurs during thumbnail attachment" do
      let(:error_message) { "Error message" }

      before do
        allow(Down).to receive(:download).and_raise(Down::Error, error_message)
      end

      it "logs a warning and does not attach the thumbnail" do
        allow(Down).to receive(:download).with(thumbnail_url, destination: anything).and_raise(Down::Error, "Failed to download thumbnail")
        allow(Rails.logger).to receive(:warn)

        expect(object.thumbnail).not_to receive(:attach)

        expect do
          described_class.new.attach_thumbnail(object, thumbnail_url)
        end.not_to change { object.thumbnail }

        expect(Rails.logger).to have_received(:warn).with(/Failed to download thumbnail/)
      end
    end
  end
end
