# frozen_string_literal: true

class Video::FacetBuilder
  class Facet
    attr_reader :name

    def initialize(name:, &block)
      @name = name
      @block = block
    end

    def options
      @options ||= @block.call.map do |(name, value), count|
        Option.new(label: name, value:, count:)
      end.sort_by(&:count).reverse.take(10)
    end
  end

  Option = Struct.new(:value, :label, :count, keyword_init: true)

  def initialize(video_relation)
    @video_relation = video_relation
  end

  def leader
    Facet.new(name: "leader") do
      Dancer.joins(:dancer_videos)
        .where(dancer_videos: {role: "leader", video_id: @video_relation.select(:id)})
        .group("dancers.name", "dancers.slug")
        .count
    end
  end

  def follower
    Facet.new(name: "follower") do
      Dancer.joins(:dancer_videos)
        .where(dancer_videos: {role: "follower", video_id: @video_relation.select(:id)})
        .group("dancers.name", "dancers.slug")
        .count
    end
  end

  def orchestra
    Facet.new(name: "orchestra") do
      @video_relation
        .joins(song: :orchestra)
        .group("orchestras.name", "orchestras.slug")
        .count
    end
  end

  def genre
    Facet.new(name: "genre") do
      @video_relation
        .joins(:song)
        .where("LOWER(songs.genre) IN ('tango', 'milonga', 'vals')")
        .group("LOWER(songs.genre)")
        .count
    end
  end

  def year
    Facet.new(name: "year") do
      @video_relation
        .group(:upload_date_year)
        .count
    end
  end

  def song
    Facet.new(name: "song") do
      @video_relation
        .joins(:song)
        .group("songs.title", "songs.slug")
        .count
    end
  end

  def event
    Facet.new(name: "event") do
      @video_relation
        .joins(:event)
        .group("events.title", "events.slug")
        .count
    end
  end

  private

  def custom_titleize(name)
    name.split("'")&.map(&:titleize)&.join("'")
  end
end
