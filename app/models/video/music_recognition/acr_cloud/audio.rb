class Video::MusicRecognition::AcrCloud::Audio
  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video_audio = fetch_by_id(youtube_id)
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def import
    transcode
    output_file_path
  end

  private

  def fetch_by_id(_youtube_id)
    YoutubeDL.download(
      "https://www.youtube.com/watch?v=#{@youtube_id}",
      { format: "140", output: "~/environment/data/audio/%(id)s.mp3" }
    )
  end

  def audio_file_path
    @youtube_video_audio.filename.to_s
  end

  def output_file_path
    calculate_time
    audio_file_path.gsub(/.mp3/, "_#{@time_1}_#{@time_2}.mp3")
  end

  def calculate_time
    @time_1 = @youtube_video_audio.duration / 2
    @time_2 = @time_1 + 20
  end

  def transcode
    song = FFMPEG::Movie.new(audio_file_path)
    song.transcode(output_file_path, { custom: %W[-ss #{@time_1} -to #{@time_2}] })
  end
end
