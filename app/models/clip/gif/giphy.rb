# frozen_string_literal: true

class Clip::Gif::Giphy
  GIPHY_API_KEY = Rails.application.credentials[Rails.env.to_sym].dig(:giphy, :api_key).freeze
  URI = URI("http://upload.giphy.com/v1/gifs").to_s.freeze
  USERNAME = "TangoTubeTV"

  class << self
    def upload(file_path)
      uploader = new(file_path)
      uploader.id
      uploader
    end
  end

  def initialize(configuration)
    @file_path = configuration[:file_path]
  end

  def upload
    faraday = Faraday.new do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    response = faraday.post(URI, body)
    response.body
  end

  def id
    @id ||= JSON.parse(upload)["data"]["id"]
  end

  def body
    {
      api_key: GIPHY_API_KEY,
      username: USERNAME,
      file: gif_file
    }
  end

  def gif_file
    Faraday::UploadIO.new(@file_path, "gif")
  end
end
