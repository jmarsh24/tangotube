# frozen_string_literal: true

class Video::MusicRecognition::AcrCloud::Client
  ACR_CLOUD_HTTP_METHOD = "POST"
  ACR_CLOUD_HTTP_URI = "/v1/identify"
  ACR_CLOUD_DATA_TYPE = "audio"
  ACR_CLOUD_SIGNATURE_VERSION = "1"
  ACR_CLOUD_TIMESTAMP = Time.now.utc.to_i.to_s.freeze
  ACR_CLOUD_ACCESS_KEY = ENV["ACR_CLOUD_ACCESS_KEY"] || Config.acr_cloud_access_key!
  ACR_CLOUD_ACCESS_SECRET = ENV["ACR_CLOUD_SECRET_KEY"] || Config.acr_cloud_secret_key!
  ACR_CLOUD_REQ_URL = "http://identify-eu-west-1.acrcloud.com/v1/identify"

  class << self
    def send_audio(file_path)
      new(file_path).get_audio_from_acr_cloud
    end
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def get_audio_from_acr_cloud
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
      sample: sample_file,
      access_key: ACR_CLOUD_ACCESS_KEY,
      data_type: ACR_CLOUD_DATA_TYPE,
      signature_version: ACR_CLOUD_SIGNATURE_VERSION,
      signature:,
      sample_bytes:,
      timestamp: ACR_CLOUD_TIMESTAMP
    }
  end

  def sample_file
    Faraday::UploadIO.new(@file_path, "audio/mp3")
  end

  def url
    URI.parse(ACR_CLOUD_REQ_URL)
  end

  def sample_bytes
    File.size(@file_path)
  end

  def unsigned_string
    "#{ACR_CLOUD_HTTP_METHOD}\n#{ACR_CLOUD_HTTP_URI}\n#{ACR_CLOUD_ACCESS_KEY}\n#{ACR_CLOUD_DATA_TYPE}\n#{ACR_CLOUD_SIGNATURE_VERSION}\n#{ACR_CLOUD_TIMESTAMP}"
  end

  def digest
    OpenSSL::Digest.new("sha1")
  end

  def signature
    Base64.encode64(OpenSSL::HMAC.digest(digest, ACR_CLOUD_ACCESS_SECRET, unsigned_string)).strip
  end
end
