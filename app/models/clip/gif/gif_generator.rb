class Clip::Gif::GifGenerator
  SIZE="400x225".freeze

  class << self
    def generate(configuration)
      generator = new(configuration)
      generator.generate
      generator
    end
  end

  attr_reader :source_file, :start_time, :end_time, :output_path
  def initialize(configuration)
    @source_file = configuration[:source_file]
    @start_time  = configuration[:start_time]
    @end_time    = configuration[:end_time]
  end

  def generate
    system("ffmpeg -i #{source_file} -ss #{start_time} -to #{end_time} -pix_fmt rgb8 -r 10 -s #{SIZE} #{output_path}")
  end

  def output_path
    "/tmp/#{File.basename(source_file, '.*')}_#{start_time}_#{end_time}.webp"
  end

end
