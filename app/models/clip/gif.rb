# frozen_string_literal: true

class Clip::Gif
  class << self
    def create(configuration)
      gif = new(configuration)
      gif.id
      gif
    end
  end

  attr_reader :id
  def initialize(configuration)
    @youtube_id = configuration[:youtube_id]
    @start_time = configuration[:start_time]
    @end_time = configuration[:end_time]
  end

  def generate_gif
    GifGenerator.generate({
      source_file: VideoDownloader.download(@youtube_id).download_path,
      start_time: @start_time,
      end_time: @end_time
    })
  end

  def upload_gif
    Giphy.upload(file_path: generate_gif.output_path)
  end

  def id
    @id ||= upload_gif.id
  end
end
