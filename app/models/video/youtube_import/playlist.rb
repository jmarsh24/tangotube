class Video::YoutubeImport::Playlist
  class << self
    def import(playlist_id)
      new(playlist_id).import
    end

    def import_videos(playlist_id)
      new(playlist_id).import_videos
    end

    def import_channels(playlist_id)
      new(playlist_id).import_channels
    end
  end

  def initialize(playlist_id)
    @youtube_playlist = fetch_by_id(playlist_id)
  end

  def import
    @playlist = Playlist.create(to_playlist_params)
  end

  def import_videos
    new_videos.each do |youtube_id|
      ImportVideoWorker.perform_async(youtube_id)
    end
  end

  def import_channels
    new_channels.each do |channel_id|
      ImportChannelWorker.perform_async(channel_id)
    end
  end

  private

  def fetch_by_id(playlist_id)
    Yt::Playlist.new id: playlist_id
  end

  def to_playlist_params
    base_params.merge(count_params)
  end

  def base_params
    {
      slug:          @youtube_playlist.id,
      title:         @youtube_playlist.title,
      description:   @youtube_playlist.description,
      channel_title: @youtube_playlist.channel_title,
      channel_id:    @youtube_playlist.channel_id
    }
  end

  def count_params
    {
      video_count: @youtube_playlist.playlist_items.count
    }
  end

  def youtube_playlist_videos
    @youtube_playlist.playlist_items.map(&:video_id)
  end

  def youtube_playlist_channels
    @youtube_playlist.playlist_items.map { |video| video.snippet.data["videoOwnerChannelId"] }.uniq
  end

  def channels
    Channel.all.map(&:channel_id).to_a
  end

  def new_channels
    youtube_playlist_channels - channels
  end

  def videos
    Video.all.map(&:youtube_id).to_a
  end

  def new_videos
    youtube_playlist_videos - videos
  end
end
