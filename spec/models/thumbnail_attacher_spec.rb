# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThumbnailAttacher do
  let(:object) { double("Object", thumbnail: double("Thumbnail")) }
  let(:thumbnail_url) { "https://example.com/thumbnail.jpg" }

  describe "#attach_thumbnail" do
    context "when thumbnail URL is not blank" do
      it "attaches the thumbnail to the object" do
        allow(object).to receive(:class).and_return(Object)

        downloaded_image = double("DownloadedImage", path: "image_path", content_type: "image/jpeg")
        expect(Down).to receive(:download).with(thumbnail_url).and_return(downloaded_image)
        expect(object.thumbnail).to receive(:attach).with(
          io: downloaded_image,
          filename: File.basename(downloaded_image.path),
          content_type: downloaded_image.content_type
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
        allow(Rails.logger).to receive(:warn)
      end

      it "logs a warning and does not attach the thumbnail" do
        expect(Rails.logger).to receive(:warn).with(/Failed to download thumbnail/)

        expect(object.thumbnail).not_to receive(:attach)

        expect do
          described_class.new.attach_thumbnail(object, thumbnail_url)
        end.not_to change { object.thumbnail }
      end
    end
  end
end
