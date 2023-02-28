class AcrCloud
  HTTP_METHOD = "POST".freeze
  HTTP_URI = "/v1/identify".freeze
  DATA_TYPE = "audio".freeze
  SIGNATURE_VERSION = "1".freeze
  REQ_URL = "http://identify-eu-west-1.acrcloud.com/v1/identify".freeze

  def upload(audio_file)
    JSON.parse HTTParty.post(REQ_URL, body: body(audio_file)), symbolize_names: true
  end

  private

  def body(audio_file)
    {
      sample: audio_file,
      access_key: Config.acr_cloud_access_key!,
      data_type: DATA_TYPE,
      signature_version: SIGNATURE_VERSION,
      signature:,
      sample_bytes: sample_bytes(audio_file),
      timestamp:
    }
  end

  def sample_bytes(audio_file)
    audio_file.size
  end

  def unsigned_string
    "#{HTTP_METHOD}\n#{HTTP_URI}\n#{Config.acr_cloud_access_key!}\n#{DATA_TYPE}\n#{SIGNATURE_VERSION}\n#{timestamp}"
  end

  def digest
    OpenSSL::Digest.new("sha1")
  end

  def signature
    Base64.encode64(OpenSSL::HMAC.digest(digest, Config.acr_cloud_secret_key!, unsigned_string)).strip
  end

  def timestamp
    Time.now.utc.to_i.to_s
  end
end
