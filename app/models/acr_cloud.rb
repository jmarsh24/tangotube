class AcrCloud
  HTTP_METHOD = "POST".freeze
  HTTP_URI = "/v1/identify".freeze
  DATA_TYPE = "audio".freeze
  SIGNATURE_VERSION = "1".freeze
  TIMESTAMP = Time.now.utc.to_i.to_s.freeze
  REQ_URL = "http://identify-eu-west-1.acrcloud.com/v1/identify".freeze

  attr_reader :data

  def self.send(sound_file:)
    new(sound_file).tap(&:send)
  end

  def initialize(sound_file)
    @sound_file = sound_file
    @data = {}
  end

  def send
    @data = JSON.parse HTTParty.post(
      REQ_URL,
      body: body
    )
  end

  private

  def body
    {
      sample: @sound_file,
      access_key: Config.acr_cloud_access_key!,
      data_type: DATA_TYPE,
      signature_version: SIGNATURE_VERSION,
      signature:,
      sample_bytes:,
      timestamp: TIMESTAMP
    }
  end

  def sample_bytes
    File.size(@sound_file)
  end

  def unsigned_string
    "#{HTTP_METHOD}\n#{HTTP_URI}\n#{Config.acr_cloud_access_key!}\n#{DATA_TYPE}\n#{SIGNATURE_VERSION}\n#{TIMESTAMP}"
  end

  def digest
    OpenSSL::Digest.new("sha1")
  end

  def signature
    Base64.encode64(OpenSSL::HMAC.digest(digest, Config.acr_cloud_secret_key!, unsigned_string)).strip
  end
end
