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
  include Filterable

  # validates :leader, presence: true
  # validates :follower, presence: true
  # validates :song, presence: true
  # validates :artist, presence: true
  # validates :youtube_id, presence: true, uniqueness: true
  # validates :title, presence: true

  belongs_to :leader
  belongs_to :follower
  belongs_to :song
  belongs_to :videotype
  belongs_to :event

  scope :genre, ->(genre) { joins(:song).where( songs: { genre: genre} ) }
  scope :videotype, ->(videotype) { joins(:videotype).where( videotypes: { name: videotype } ) }
  scope :leader, ->(leader) { joins(:leader).where( leaders: { name: leader } ) }
  scope :follower, ->(follower) { joins(:follower).where( followers: { name: follower } ) }
  scope :event, ->(event) { joins(:event).where( events: { name: event } ) }
  scope :channel, ->(channel) { where( channel: channel ) }

  scope :paginate, ->(page, per_page)  {
    offset(per_page * page).limit(per_page)
  }

  def self.search(query)
    if query
      where( 'leaders.name ILIKE :query or 
              followers.name ILIKE :query or 
              songs.genre ILIKE :query or 
              songs.title ILIKE :query or 
              songs.artist ILIKE :query or 
              videotypes.name ILIKE :query',  
              query: "%#{query.downcase}%" )
    else
      all
    end
  end

  class << self
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
           #video.grep_title
           video.save
       end
    end
  end

  class << self
    def grep_title
      # Grep Leader from Title
      self.leader = Leader.all.find { |leader| title.match(leader.name) }
      # Grep Follower from Title
      self.follower = Follower.all.find { |follower| title.match(follower.name) }
    end

    def match_dancers
          Leader.all.each do |leader|
            Video.search_by_keyword(leader.name).each do |video|
              if video.leader.nil?
                self.leader = leader
                video.save
              end
            end
          end

          Follower.all.each do |follower|
            Video.search_by_keyword(follower.name).each do |video|
              if video.follower.nil?
                video.follower = follower
                video.save
            end
          end
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
  end
end