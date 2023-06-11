# frozen_string_literal: true

class ChannelVideoFetcher
  def initialize(channel_id, use_scraper: true, use_music_recognizer: true)
    @channel_id = channel_id
    @use_scraper = use_scraper
    @use_music_recognizer = use_music_recognizer
  end

  def fetch_new_videos
    external_video_ids = fetch_external_videos
    internal_video_ids = fetch_internal_videos

    new_video_ids = calculate_new_video_ids(external_video_ids, internal_video_ids)

    import_new_videos(new_video_ids)
  end

  private

  def fetch_external_videos
    youtube_channel = Yt::Channel.new(id: @channel_id)
    youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id) || youtube_channel.videos.map(&:id)
  end

  def fetch_internal_videos
    channel = Channel.find_by(channel_id: @channel_id)
    channel.videos.pluck(:youtube_id)
  end

  def calculate_new_video_ids(external_video_ids, internal_video_ids)
    external_video_ids - internal_video_ids
  end

  def import_new_videos(new_video_ids)
    new_video_ids.each do |video_id|
      ImportVideoJob.perform_later(video_id, use_scraper: @use_scraper, use_music_recognizer: @use_music_recognizer)
    end
  end
end
