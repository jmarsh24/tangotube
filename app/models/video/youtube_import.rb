# frozen_string_literal: true

class Video::YoutubeImport
  class << self
    def from_channel(channel_id)
      Channel.import(channel_id)
      Channel.import_videos(channel_id)
    end

    def from_playlist(playlist_id)
      Playlist.import(playlist_id)
      Playlist.import_videos(playlist_id)
    end

    def from_video(youtube_id)
      Video.import(youtube_id)
    end
  end
end
