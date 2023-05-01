# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::ChannelMatcher do
  fixtures :channels

  let(:thumbnail_attacher) { instance_double(ExternalVideoImport::MetadataProcessing::ThumbnailAttacher) }
  let(:channel_matcher) { described_class.new(thumbnail_attacher) }
  let(:existing_channel) { channels(:"030tango") }

  describe "#match_or_create" do
    context "when the channel exists" do
      let(:channel_metadata) { ExternalVideoImport::Youtube::ChannelMetadata.new(id: existing_channel.channel_id, thumbnail_url: "https://yt3.ggpht.com/ytc/AL5GRJVepNM3-zJP50OTXSq6fXyvHB3F9nzST-3sJ2P5=s68-c-k-c0x00ffffff-no-rj") }

      it "returns the matching channel" do
        expect(channel_matcher.match_or_create(channel_metadata: channel_metadata)).to eq(existing_channel)
      end

      it "does not call the ThumbnailAttacher" do
        expect(thumbnail_attacher).not_to receive(:attach_thumbnail)
        channel_matcher.match_or_create(channel_metadata: channel_metadata)
      end
    end

    context "when the channel does not exist" do
      let(:channel_metadata) { ExternalVideoImport::Youtube::ChannelMetadata.new(id: "new_slug", thumbnail_url: "https://yt3.ggpht.com/ytc/AL5GRJVepNM3-zJP50OTXSq6fXyvHB3F9nzST-3sJ2P5=s68-c-k-c0x00ffffff-no-rj") }
      let(:new_channel) { instance_double(::Channel) }

      before do
        allow(::Channel).to receive(:create!).and_return(new_channel)
        allow(thumbnail_attacher).to receive(:attach_thumbnail)
      end

      it "creates a new channel" do
        expect(::Channel).to receive(:create!).and_return(new_channel)
        channel_matcher.match_or_create(channel_metadata: channel_metadata)
      end

      it "returns the newly created channel" do
        expect(channel_matcher.match_or_create(channel_metadata: channel_metadata)).to eq(new_channel)
      end

      it "calls the ThumbnailAttacher with the correct arguments" do
        expect(thumbnail_attacher).to receive(:attach_thumbnail).with(new_channel, "https://yt3.ggpht.com/ytc/AL5GRJVepNM3-zJP50OTXSq6fXyvHB3F9nzST-3sJ2P5=s68-c-k-c0x00ffffff-no-rj")
        channel_matcher.match_or_create(channel_metadata: channel_metadata)
      end
    end
  end
end
