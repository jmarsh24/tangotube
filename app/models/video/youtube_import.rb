class Video::YoutubeImport
  class << self
    def from_channel(channel_id)
      Channel.import(channel_id)
    end

    def from_playlist(playlist_id)
      Playlist.import(playlist_id)
    end

    def from_video(video_id)
      Video.import(video_id)
    end
  end
end
