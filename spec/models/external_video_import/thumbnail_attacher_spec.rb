require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::ThumbnailAttacher do
  let(:video) { instance_double("Video") }
  let(:thumbnail_url) { "https://example.com/thumbnail.jpg" }

  before do
    allow(video).to receive(:youtube_id).and_return("test_video_slug")
  end

  describe ".attach_thumbnail" do
    context "when thumbnail URL is not blank" do
      it "attaches the thumbnail to the video" do
        expect(Down).to receive(:download).with(thumbnail_url, destination: instance_of(String)).and_return(true)

        thumbnail_instance = instance_double("Thumbnail")
        allow(video).to receive(:thumbnail).and_return(thumbnail_instance)

        tempfile = Tempfile.new(["thumbnail", ".jpg"])
        allow(Tempfile).to receive(:open).and_yield(tempfile)

        expect(thumbnail_instance).to receive(:attach).with(
          io: tempfile,
          filename: "#{video.youtube_id}.jpg"
        )

        described_class.attach_thumbnail(video, thumbnail_url)
      end
    end

    context "when thumbnail URL is blank" do
      it "does not attach the thumbnail to the video" do
        expect(Down).not_to receive(:download)
        thumbnail_instance = instance_double("Thumbnail")
        allow(video).to receive(:thumbnail).and_return(thumbnail_instance)

        expect do
          described_class.attach_thumbnail(video, "")
        end.not_to change { video.thumbnail }

        expect(thumbnail_instance).not_to receive(:attach)
      end
    end

    context "when an error occurs during thumbnail attachment" do
      let(:error_message) { "Error message" }

      before do
        allow(Down).to receive(:download).and_raise(Down::Error, error_message)
      end

      it "logs a warning and does not attach the thumbnail" do
        expect(Down).to receive(:download).with(thumbnail_url, destination: anything).and_raise(Down::Error, "Failed to download thumbnail")
        thumbnail_instance = instance_double("Thumbnail")
        allow(video).to receive(:thumbnail).and_return(thumbnail_instance)

        expect(Rails.logger).to receive(:warn).with(/Failed to download thumbnail/)
        expect(video.thumbnail).not_to receive(:attach)

        expect do
          described_class.attach_thumbnail(video, thumbnail_url)
        end.not_to change { video.thumbnail }
      end
    end
  end
end
