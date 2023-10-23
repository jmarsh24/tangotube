# frozen_string_literal: true

class Video::FacetBuilder
  class Facet
    attr_reader :name

    def initialize(name:, option_builder: nil, &block)
      @name = name
      @block = block
      @option_builder = option_builder
    end

    def options
      @options ||= @block.call.map do |name, count|
        @option_builder.call(name, count)
      end
    end
  end

  Option = Data.define(:value, :label, :count)

  def initialize(video_relation)
    @video_relation = video_relation
  end

  def leader
    Facet.new(name: "leader", option_builder: ->(name, count) { Option.new(label: name[0], value: name[1], count:) }) do
      Dancer.joins(:dancer_videos)
        .where(dancer_videos: {role: "leader", video_id: @video_relation.select(:id)})
        .group("dancers.name", "dancers.slug", "dancers.videos_count")
        .order(Arel.sql("COUNT(*) DESC"), "dancers.videos_count DESC")
        .limit(30)
        .count
    end
  end

  def follower
    Facet.new(name: "follower", option_builder: ->(name, count) { Option.new(label: name[0], value: name[1], count:) }) do
      Dancer.joins(:dancer_videos)
        .where(dancer_videos: {role: "follower", video_id: @video_relation.select(:id)})
        .group("dancers.name", "dancers.slug", "dancers.videos_count")
        .order(Arel.sql("COUNT(*) DESC"), "dancers.videos_count DESC")
        .limit(30)
        .count
    end
  end

  def orchestra
    Facet.new(name: "orchestra", option_builder: ->(name, count) { Option.new(label: custom_titleize(name[0]), value: name[1], count:) }) do
      @video_relation
        .joins(song: :orchestra)
        .group("orchestras.name", "orchestras.slug", "orchestras.videos_count")
        .order(Arel.sql("COUNT(*) DESC"), "orchestras.videos_count DESC")
        .limit(30)
        .count
    end
  end

  def genre
    Facet.new(name: "genre", option_builder: ->(name, count) { Option.new(label: name.titleize, value: name, count:) }) do
      @video_relation
        .joins(:song)
        .where("LOWER(songs.genre) IN ('tango', 'milonga', 'vals', 'alternative')")
        .group("LOWER(songs.genre)")
        .order("count_all DESC", "LOWER(songs.genre)")
        .limit(30)
        .count
    end
  end

  def year
    Facet.new(name: "year", option_builder: ->(name, count) { Option.new(label: name, value: name, count:) }) do
      @video_relation
        .group(:upload_date_year)
        .order(upload_date_year: :desc)
        .limit(30)
        .count
    end
  end

  def song
    Facet.new(name: "song", option_builder: ->(name, count) { Option.new(label: name[0], value: name[1], count:) }) do
      @video_relation
        .joins(song: :orchestra)
        .group("songs.display_title", "songs.slug", "songs.videos_count")
        .order(Arel.sql("COUNT(*) DESC"), "songs.videos_count DESC")
        .limit(30)
        .count
    end
  end

  def event
    Facet.new(name: "event", option_builder: ->(name, count) { Option.new(label: name[0], value: name[1], count:) }) do
      @video_relation
        .joins(:event)
        .group("events.title", "events.slug", "events.videos_count")
        .order("count_all DESC", "events.title")
        .limit(30)
        .count
    end
  end

  def couple
    Facet.new(name: "couple", option_builder: ->(data, count) { Option.new(label: data[0], value: data[1], count:) }) do
      @video_relation
        .joins(couple_videos: :couple)
        .joins("INNER JOIN dancers AS leader ON leader.id = couples.dancer_id")
        .joins("INNER JOIN dancers AS follower ON follower.id = couples.partner_id")
        .group("leader.name", "follower.name", "couples.slug")
        .order(Arel.sql("COUNT(couple_videos.id) DESC, leader.name, follower.name"))
        .limit(30)
        .count("couple_videos.id")
        .map { |(leader_name, follower_name, slug), count| [["#{leader_name} & #{follower_name}", slug], count] }
    end
  end

  def channel
    Facet.new(name: "channel", option_builder: ->(name, count) { Option.new(label: name[0], value: name[1], count:) }) do
      @video_relation
        .joins(:channel)
        .group("channels.title", "channels.youtube_slug", "channels.videos_count")
        .order("count_all DESC", "channels.title")
        .limit(30)
        .count
    end
  end

  private

  def custom_titleize(name)
    name&.split("'")&.map(&:titleize)&.join("'")
  end
end
