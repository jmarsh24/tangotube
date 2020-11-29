# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :text
#  youtube_id         :string
#  leader_id          :bigint
#  follower_id        :bigint
#  description        :string
#  channel            :string
#  channel_id         :string
#  duration           :integer
#  upload_date        :date
#  view_count         :integer
#  avg_rating         :integer
#  tags               :string
#  song_id            :bigint
#  youtube_song       :string
#  youtube_artist     :string
#  performance_date   :datetime
#  performance_number :integer
#  performance_total  :integer
#  videotype_id       :bigint
#  event_id           :bigint
#

class Video < ApplicationRecord
  include Houndify

  require "openssl"
  require "base64"
  require "net/http/post/multipart"
  require "irb"
  require "json"
  require "securerandom"
  require "houndify"


  # validates :leader, presence: true
  # validates :follower, presence: true
  # validates :song, presence: true
  # validates :artist, presence: true
  # validates :youtube_id, presence: true, uniqueness: true
  # validates :title, presence: true

  belongs_to :leader, required: false
  belongs_to :follower, required: false
  belongs_to :song, required: false
  belongs_to :videotype, required: false
  belongs_to :event, required: false

  scope :genre, ->(genre) { joins(:song).where(songs: {genre: genre}) }
  scope :videotype, ->(videotype) { joins(:videotype).where(videotypes: {name: videotype}) }
  scope :leader, ->(leader) { joins(:leader).where(leaders: {name: leader}) }
  scope :follower, ->(follower) { joins(:follower).where(followers: {name: follower}) }
  scope :event, ->(event) { joins(:event).where(events: {name: event}) }
  scope :channel, ->(channel) { where(channel: channel) }

  scope :paginate, lambda { |page, per_page|
    offset(per_page * page).limit(per_page)
  }

  class << self
    def search(query)
      if query
        where('leaders.name ILIKE :query or
                followers.name ILIKE :query or
                songs.genre ILIKE :query or
                songs.title ILIKE :query or
                songs.artist ILIKE :query or
                videotypes.name ILIKE :query',
          query: "%#{query.downcase}%")
      else
        all
      end
    end

    # To fetch video, run this from the console:
    # Video.parse_json('data/030tango_channel_data_json')
    # Video.parse_json('/Users/justin/desktop/environment/data/channel_json')
    def parse_json(file_path)
      json_file = Dir.glob("#{file_path}/**/*.json").map
      json_file.each do |youtube_video|
        video = JSON.parse(File.read(youtube_video))
        video = Video.new(
          youtube_id: video["id"],
          title: video["title"],
          description: video["description"],
          youtube_song: video["track"],
          youtube_artist: video["artist"],
          upload_date: video["upload_date"],
          channel: video["uploader"],
          duration: video["duration"],
          channel_id: video["uploader_id"],
          view_count: video["view_count"],
          avg_rating: video["average_rating"],
          tags: video["tags"]
        )
        # video.grep_title
        video.save
      end
    end

    # To fetch video, run this from the console:
    # Video.for_channel('UCtdgMR0bmogczrZNpPaO66Q')
    def for_channel(id)
      channel = Yt::Channel.new id: id
      channel.videos.each do |youtube_video|
        video = Video.new(youtube_id: youtube_video.id, title: youtube_video.title)
        video.grep_title
        video.save
      end
    end

    def youtube_trim(youtube_id, time_1, time_2)
      youtube_video = YoutubeDL.download(
        "https://www.youtube.com/watch?v=#{youtube_id}",
        {format: "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best",
        output: "~/downloads/youtube/%(title)s-%(id)s.%(ext)s"}
      )
      video = FFMPEG::Movie.new(youtube_video.filename.to_s)
      timestamp = "#{time_1}".split(":")
      timestamp_2 = "#{time_2}".split(":")
      output_file_path = youtube_video.filename.gsub(/.mp4/, "_trimmed_#{timestamp[1]}_#{timestamp[2]}_to_#{timestamp_2[1]}_#{timestamp_2[2]}.mp4")
          video_transcoded = video.transcode(output_file_path, custom: %W[-ss #{time_1} -to #{time_2}])
    end

    def ask_hound(user_id, query)
      @regex_hastag = /#\w+/
      query = query.gsub(@regex_hastag, '')
      info query
      client = Houndify::Client.new(user_id)
      response = client.request(query)
      info response
      publish 'hound-bot', response
      response['AllResults'][0]['SpokenResponseLong']
    end

    def houndify_sound_match(user_id, file_path)
      Houndify.set_secrets(ENV['HOUNDIFY_CLIENT_ID'],
                           ENV['HOUNDIFY_CLIENT_KEY'])
      client = Houndify::Client.new(user_id)
      response = client.sound_match(file_path)
      response
      ap JSON.parse(response.body)
    end
  end
end
