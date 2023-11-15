# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::ChannelMatcher do
  fixtures :all
  let(:channel_matcher) { described_class.new }
  let(:existing_channel) { channels(:"030tango") }

  describe "#match_or_create" do
    context "when the channel exists" do
      let(:channel_metadata) {
        ExternalVideoImport::Youtube::ChannelMetadata.new(
          id: existing_channel.youtube_slug,
          thumbnail_url: "https://yt3.ggpht.com/ytc/AL5GRJVepNM3-zJP50OTXSq6fXyvHB3F9nzST-3sJ2P5=s68-c-k-c0x00ffffff-no-rj"
        )
      }

      it "returns the matching channel" do
        expect(channel_matcher.match_or_create(channel_metadata:)).to eq(existing_channel)
      end
    end

    context "when the channel does not exist" do
      it "returns the newly created channel", :vcr do
        channel = channels(:jkukla_video)
        youtube_slug = channel.youtube_slug
        channel_metadata = ExternalVideoImport::Youtube::ChannelMetadata.new(
          id: youtube_slug,
          thumbnail_url: "https://yt3.ggpht.com/ytc/AL5GRJVepNM3-zJP50OTXSq6fXyvHB3F9nzST-3sJ2P5=s68-c-k-c0x00ffffff-no-rj"
        )

        channel.destroy!

        expect(channel_matcher.match_or_create(channel_metadata:)).to eq(Channel.find_by(youtube_slug:))
      end
    end
  end
end
