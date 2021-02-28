class Video::YoutubeImport::Video
  class << self
    def fetch_youtube_song(youtube_id)
      video = Video.find_by(youtube_id: youtube_id)
      yt_video = JSON.parse(YoutubeDL.download("https://www.youtube.com/watch?v=#{youtube_id}", skip_download: true)
                                  .to_json).extend Hashie::Extensions::DeepFind
      if yt_video.present?
        video.update(youtube_song:          yt_video.deep_find("track"),
                     youtube_artist:        yt_video.deep_find("artist"),
                     scanned_youtube_music: true)
      else
        queue = Sidekiq::Queue.new("default")
        queue.count
        queue.clear
        queue.each { |job| job.item }
      end
    end

    # To fetch specific snippet from video, run this in the console:

    # Video.youtube_trim("5HfJ_n3wvLw","00:02:40.00", "00:02:55.00")
    def youtube_trim(youtube_id, time_1, time_2)
      youtube_video = YoutubeDL.download(
        "https://www.youtube.com/watch?v=#{youtube_id}",
        { format: "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best",
          output: "~/downloads/youtube/%(title)s-%(id)s.%(ext)s" }
      )
      video = FFMPEG::Movie.new(youtube_video.filename.to_s)
      timestamp = time_1.to_s.split(":")
      timestamp_2 = time_2.to_s.split(":")
      output_file_path = youtube_video.filename.gsub(/.mp4/,
                                                     "_trimmed_#{timestamp[1]}_#{timestamp[2]}_to_#{timestamp_2[1]}_#{timestamp_2[2]}.mp4")
      video_transcoded = video.transcode(output_file_path, custom: %W[-ss #{time_1} -to #{time_2}])
    end
  end
end
