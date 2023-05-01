# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::VideoUpdater, type: :model do
  fixtures :videos
  let(:video) { videos(:video_1_featured) }
  let(:metadata_yaml) { YAML.load_file(Rails.root.join("spec/fixtures/metadata.yml")) }
  let(:metadata) { ExternalVideoImport::Metadata.new(metadata_yaml["metadata"]) }

  subject { described_class.new(video) }

  describe "#update" do
    it "updates the video with the provided metadata" do
      expect(video).to receive(:update!).with(metadata: metadata)
      expect_any_instance_of(ExternalVideoImport::MetadataProcessing::ThumbnailAttacher).to receive(:attach_thumbnail)

      subject.update(metadata)
    end

    it "logs an error and raises an exception if the video update fails" do
      allow(video).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      allow(Rails.logger).to receive(:error)

      expect {
        subject.update(metadata)
      }.to raise_error(ExternalVideoImport::VideoUpdateError)

      expect(Rails.logger).to have_received(:error).once
    end
  end
end
