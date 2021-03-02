class Video::MusicRecognition::AcrCloud::Client
  class << self
    def send_audio(file_path)
      new(file_path).call
    end
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    send_audio_file
  end

  private

  def send_audio_file
    requrl = "http://identify-eu-west-1.acrcloud.com/v1/identify"
    access_key = ENV["ACRCLOUD_ACCESS_KEY"]
    access_secret = ENV["ACRCLOUD_SECRET_KEY"]

    http_method = "POST"
    http_uri = "/v1/identify"
    data_type = "audio"
    signature_version = "1"
    timestamp = Time.now.utc.to_i.to_s

    string_to_sign = http_method + "\n" + http_uri + "\n" + access_key + "\n" + data_type + "\n" + signature_version + "\n" + timestamp

    digest = OpenSSL::Digest.new("sha1")
    signature = Base64.encode64(OpenSSL::HMAC.digest(digest, access_secret, string_to_sign))

    sample_bytes = File.size(@file_path)

    url = URI.parse(requrl)
    File.open(@file_path) do |file|
      req = Net::HTTP::Post::Multipart.new url.path,
                                           "sample"            => UploadIO.new(file, "audio/mp3", @file_path),
                                           "access_key"        => access_key,
                                           "data_type"         => data_type,
                                           "signature_version" => signature_version,
                                           "signature"         => signature,
                                           "sample_bytes"      => sample_bytes,
                                           "timestamp"         => timestamp
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      body = res.body.force_encoding("utf-8")
      body
    end
  end
end
