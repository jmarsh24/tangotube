# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::ChannelMatcher do
  fixtures :all

  let(:channel_matcher) { described_class.new }
  let(:existing_channel) { channels(:"030tango") }

  describe "#match_or_create" do
    context "when the channel exists" do
      let(:channel_metadata) { ExternalVideoImport::Youtube::ChannelMetadata.new(id: existing_channel.channel_id) }

      it "returns the matching channel" do
        expect(channel_matcher.match_or_create(channel_metadata: channel_metadata)).to eq(existing_channel)
      end
    end

    context "when the channel does not exist" do
      let(:channel_metadata) { ExternalVideoImport::Youtube::ChannelMetadata.new(id: "new_slug") }

      it "creates a new channel" do
        expect { channel_matcher.match_or_create(channel_metadata: channel_metadata) }.to change { ::Channel.count }.by(1)
      end

      it "returns the newly created channel" do
        new_channel = channel_matcher.match_or_create(channel_metadata: channel_metadata)
        expect(new_channel).to be_an_instance_of(::Channel)
        expect(new_channel.channel_id).to eq("new_slug")
      end
    end
  end
end
