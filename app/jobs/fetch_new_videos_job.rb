# frozen_string_literal: true

class FetchNewVideosJob < ApplicationJob
  queue_as :default

  def perform(channel)
    youtube_channel = Yt::Channel.new(id: channel.channel_id)
    external_video_ids = youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id) || youtube_channel.videos.map(&:id)
    internal_video_ids = channel.videos.pluck(:youtube_id)
    new_video_ids = external_video_ids - internal_video_ids

    new_video_ids.each do |video_id|
      ExternalVideoImport::Importer.import(video_id, use_scraper: false)
    end
  end
end
