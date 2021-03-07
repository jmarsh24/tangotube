class Video::MusicRecognition::AcrCloud::Client
  class << self
    def send_audio(file_path)
      new(file_path).call
    end
  end

  def initialize(file_path)
    @file_path = file_path

    set_url
    set_access_keys
    create_string
    create_signed_string
    create_signature
    set_sample_size
  end

  def call
    send_via_faraday
  end

  private

  def set_url
    @requrl = "http://identify-eu-west-1.acrcloud.com/v1/identify"
    @url = URI.parse(@requrl)
  end

  def set_access_keys
    @access_key = ENV["ACRCLOUD_ACCESS_KEY"]
    @access_secret = ENV["ACRCLOUD_SECRET_KEY"]
  end

  def set_sample_size
    @sample_bytes = File.size(@file_path)
  end

  def create_string
    @http_method = "POST"
    @http_uri = "/v1/identify"
    @data_type = "audio"
    @signature_version = "1"
    @timestamp = Time.now.utc.to_i.to_s
  end

  def create_signed_string
    @string_to_sign = "#{@http_method}\n#{@http_uri}\n#{@access_key}\n#{@data_type}\n#{@signature_version}\n#{@timestamp}"
  end

  def create_signature
    digest = OpenSSL::Digest.new("sha1")
    @signature = Base64.encode64(OpenSSL::HMAC.digest(digest, @access_secret, @string_to_sign))
  end

  def send_via_faraday
    faraday = Faraday.new do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end

    response = faraday.post(@url, sample:            Faraday::UploadIO.new(@file_path, "audio/mp3"),
                                  access_key:        @access_key,
                                  data_type:         @data_type,
                                  signature_version: @signature_version,
                                  signature:         @signature,
                                  sample_bytes:      @sample_bytes,
                                  timestamp:         @timestamp)
    response.body
  end
end
