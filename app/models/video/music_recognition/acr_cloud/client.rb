class Video::MusicRecognition::AcrCloud::Client
  HTTP_METHOD = "POST".freeze
  HTTP_URI = "/v1/identify".freeze
  DATA_TYPE = "audio".freeze
  SIGNATURE_VERSION = "1".freeze
  TIMESTAMP = Time.now.utc.to_i.to_s.freeze
  ACCESS_KEY = ENV["ACRCLOUD_ACCESS_KEY"]
  ACCESS_SECRET = ENV["ACRCLOUD_SECRET_KEY"]
  REQ_URL = "http://identify-eu-west-1.acrcloud.com/v1/identify".freeze

  class << self
    def send_audio(file_path)
      new(file_path).send_audio_file_to_acr_cloud
    end
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def send_audio_file_to_acr_cloud
    faraday = Faraday.new do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end

    response = faraday.post(url, body)
    response.body
  end

  private

  def body
    {
      sample:            sample_file,
      access_key:        ACCESS_KEY,
      data_type:         DATA_TYPE,
      signature_version: SIGNATURE_VERSION,
      signature:         signature,
      sample_bytes:      sample_bytes,
      timestamp:         TIMESTAMP
    }
  end

  def sample_file
    Faraday::UploadIO.new(@file_path, "audio/mp3")
  end

  def url
    URI.parse(REQ_URL)
  end

  def sample_bytes
    File.size(@file_path)
  end

  def unsigned_string
    "#{HTTP_METHOD}\n#{HTTP_URI}\n#{ACCESS_KEY}\n#{DATA_TYPE}\n#{SIGNATURE_VERSION}\n#{TIMESTAMP}"
  end

  def digest
    OpenSSL::Digest.new("sha1")
  end

  def signature
    Base64.encode64(OpenSSL::HMAC.digest(digest, ACCESS_SECRET, unsigned_string)).strip
  end
end
