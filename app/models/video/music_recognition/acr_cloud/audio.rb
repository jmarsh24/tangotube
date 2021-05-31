class Video::MusicRecognition::AcrCloud::Audio
  YOUTUBE_DL_COMMAND_PREFIX = "youtube-dl https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_DOWNLOAD_AUDIO = " -f 140 ".freeze
  RELATIVE_SAVE_PATH = "/tmp/music/".freeze
  OUTPUT_FORMAT = ".mp3".freeze
  YOUTUBE_DL_COMMAND_OUTPUT_FILEPATH = "-o '#{Rails.root.to_s.concat("#{RELATIVE_SAVE_PATH}%(id)s#{OUTPUT_FORMAT}")}' ".freeze

  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    fetch_audio_from_youtube
  end

  def import
    transcoded_audio_file
  end

  private

  def fetch_audio_from_youtube
    system(YOUTUBE_DL_COMMAND_PREFIX + @youtube_id + YOUTUBE_DL_COMMAND_DOWNLOAD_AUDIO + YOUTUBE_DL_COMMAND_OUTPUT_FILEPATH)
    rescue StandardError => e
      Rails.logger.warn "Video::MusicRecognition::AcrCloud::Audio youtube-dl video fetching error: #{e.backtrace.join("\n\t")}"
      ""
  end

  def youtube_audio_file_path
    Rails.root.join(RELATIVE_SAVE_PATH + @youtube_id + OUTPUT_FORMAT).to_s
  end

  def output_file_path
    @output_file_path ||= youtube_audio_file_path.gsub(/#{OUTPUT_FORMAT}/,"_#{sample_start_time}_#{sample_end_time.to_s + OUTPUT_FORMAT}")
  end

  def audio_file
    FFMPEG::Movie.new(youtube_audio_file_path)
  end

  def sample_start_time
    @sample_start_time ||= audio_file.duration.to_i / 2
  end

  def sample_end_time
    @sample_end_time ||= sample_start_time + 20
  end

  def transcoded_audio_file
    audio_file.transcode(output_file_path, { custom: %W[-ss #{sample_start_time} -to #{sample_end_time}] })
  end
end
