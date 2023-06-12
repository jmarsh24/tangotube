# frozen_string_literal: true


require "rails_helper"

RSpec.describe ExternalChannelImporter do
  let(:yt_channel) { instance_double(Yt::Channel) }
  let(:slug) { "new_channel_slug" }

  before do
    allow(Yt::Channel).to receive(:new).and_return(yt_channel)
    allow(yt_channel).to receive_messages(
      id: "new_channel_slug",
      title: "youtube channel",
      description: "Some description",
      published_at: Time.current,
      thumbnail_url: "https://example.com/thumbnail",
      view_count: 1000,
      video_count: 10,
      videos: [instance_double(Yt::Video, id: "video_1")],
      playlists: [instance_double(Yt::Playlist, id: "playlist_1")],
      related_playlists: [instance_double(Yt::Playlist, id: "related_playlist_1")],
      subscriber_count: 500,
      privacy_status: "public"
    )
  end

  describe "#import" do
    it "creates a new channel with correct attributes" do
      channel = ExternalChannelImporter.new.import(slug)
      expect(channel.metadata).to be_present
      expect(channel.title).to eq(yt_channel.title)
      expect(channel.channel_id).to eq(yt_channel.id)
      expect(channel.description).to eq(yt_channel.description)
      expect(channel.thumbnail_url).to eq(yt_channel.thumbnail_url)
      expect(channel.metadata_updated_at).to be_present
    end
  end

  describe "#fetch_metadata" do
    it "returns ChannelMetadata with correct attributes" do
      metadata = ExternalChannelImporter.new.fetch_metadata(slug)
      expect(metadata.id).to eq(yt_channel.id)
      expect(metadata.title).to eq(yt_channel.title)
      expect(metadata.description).to eq(yt_channel.description)
      expect(metadata.published_at).to eq(yt_channel.published_at)
      expect(metadata.thumbnail_url).to eq(yt_channel.thumbnail_url)
      expect(metadata.view_count).to eq(yt_channel.view_count)
      expect(metadata.video_count).to eq(yt_channel.video_count)
      expect(metadata.video_ids).to eq(yt_channel.videos.map(&:id))
      expect(metadata.playlist_ids).to eq(yt_channel.playlists.map(&:id))
      expect(metadata.related_playlist_ids).to eq(yt_channel.related_playlists.map(&:id))
      expect(metadata.subscriber_count).to eq(yt_channel.subscriber_count)
      expect(metadata.privacy_status).to eq(yt_channel.privacy_status)
    end
  end
end
