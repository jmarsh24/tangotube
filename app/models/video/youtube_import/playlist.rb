class Video::YoutubeImport::Playlist
  class << self
    def import(playlist_id)
      new(playlist_id).import
    end

    def import_videos(channel_id)
      new(channel_id).import_videos
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
      channel_title: @youtube_playlist.published_at
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
    @youtube_playlist.playlist_items.map(&:channel_id).uniq
  end

  def new_channels; end

  def import_all_playlists
    Playlist.where(imported: false).find_each do |playlist|
      Video.import_playlist(playlist.slug)
    end
  end

  def import_playlist(playlist_id)
    yt_playlist = Yt::Playlist.new id: playlist_id
    yt_playlist_items = yt_playlist.playlist_items
    playlist = Playlist.find_by(slug: playlist_id)
                       .update(title:         yt_playlist.title,
                               description:   yt_playlist.description,
                               channel_title: yt_playlist.channel_title,
                               channel_id:    yt_playlist.channel_id,
                               video_count:   yt_playlist_items.size,
                               imported:      true)

    yt_playlist_items.map(&:video_id).each do |yt_video_id|
      video = Video.find_by(youtube_id: yt_video_id)
      video.update(popularity: video.popularity + 1) if video.present?
      ImportVideoWorker.perform_async(yt_video_id) if video.blank?
    end
  end
end
