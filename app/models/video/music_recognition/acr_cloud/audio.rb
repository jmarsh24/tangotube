class Video::MusicRecognition::AcrCloud::Audio
  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video_audio_file = fetch_by_id(youtube_id)
  end

  def import
    transcode_audio_file
  end

  private

  def fetch_by_id(youtube_id)
    YoutubeDL.download(
      "https://www.youtube.com/watch?v=#{@youtube_id}",
      { format: "140", output: "~/environment/data/audio/%(id)s.mp3" }
    )
  end

  def youtube_audio_file_path
    @youtube_video_audio_file.filename.to_s
  end

  def output_file_path
    @output_file_path ||= youtube_audio_file_path.gsub(/.mp3/, "_#{time_1}_#{time_2}.mp3")
  end

  def time_1
    @time_1 ||= @youtube_video_audio_file.duration / 2
  end

  def time_2
    @time_2 ||= time_1 + 20
  end

  def transcode_audio_file
    song = FFMPEG::Movie.new(youtube_audio_file_path)
    song.transcode(output_file_path, { custom: %W[-ss #{time_1} -to #{time_2}] })
    output_file_path
  end
end
