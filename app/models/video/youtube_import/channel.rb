# frozen_string_literal: true

class Video::YoutubeImport::Channel
  YOUTUBE_DL_COMMAND_PREFIX =
    "yt-dlp https://www.youtube.com/channel/"
  YOUTUBE_DL_COMMAND_SUFFIX = "/videos  --get-id --skip-download"

  class << self
    def import(channel_id)
      new(channel_id).import
    end

    def import_videos(channel_id)
      new(channel_id).import_videos
    end
  end

  def initialize(channel_id)
    @channel_id = channel_id
    @channel = Channel.find_or_create_by(channel_id:)
    @youtube_channel = fetch_by_id(channel_id)
  end

  def import
    @channel.update(to_channel_params)
  rescue Yt::Errors::NoItems
    Rails.logger.warn "Channel does not exist"
  rescue Yt::Errors::RequestError
    Rails.logger.warn "Invalid Request"
  end

  def import_videos
    return nil unless @channel.active?
    new_videos.each do |youtube_id|
      ImportVideoJob.perform_later(youtube_id)
    end
  rescue Yt::Errors::NoItems
    Rails.logger.warn "Channel does not exist"
  rescue Yt::Errors::RequestError
    Rails.logger.warn "Invalid Request"
  end

  private

  def fetch_by_id(channel_id)
    Yt::Channel.new id: channel_id
  end

  def to_channel_params
    base_params.merge(count_params)
  end

  def base_params
    {
      channel_id: @youtube_channel.id,
      title: @youtube_channel.title,
      thumbnail_url: @youtube_channel.thumbnail_url
    }
  end

  def count_params
    {total_videos_count: @youtube_channel.video_count}
  end

  def external_youtube_ids
    if @youtube_channel.video_count >= 500
      @youtube_channel.related_playlists.first.playlist_items.map(&:video_id)
    else
      @youtube_channel.videos.map(&:id)
    end
  end

  def internal_channel_youtube_ids
    @channel.videos.pluck(:youtube_id)
  end

  def new_videos
    external_youtube_ids - internal_channel_youtube_ids
  end
end
