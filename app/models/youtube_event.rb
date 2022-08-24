class YoutubeEvent < ApplicationRecord
  enum status: {
    pending: 0,
    processing: 1,
    processed: 2,
    error: 3
  }

  def youtube_id
    @youtube_id ||= data.dig("feed", "entry", "videoId") || data.dig("feed", "deleted_entry", "ref").split(":").last
  end

  def title
    @title ||= data.dig("feed", "entry", "title")
  end

  def channel_id
    @channel_id ||= data.dig("feed", "entry", "channelId")
  end

  def handle_event
    video = Video.find_by(youtube_id:)
    channel = Channel.find_by(channel_id:)
    if channel.active?
      if video.present? && data.dig("feed", "deleted_entry").present?
        video.destroy
      elsif video.present? && data.dig("feed", "deleted_entry").nil?
        video.title = title
        video.save
      else
        Video::YoutubeImport.from_video(youtube_id)
      end
    end
  end
end
