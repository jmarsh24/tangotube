# frozen_string_literal: true

class Video::FacetBuilder
  Facet = Struct.new(:name, :options, keyword_init: true)
  Option = Struct.new(:value, :label, :count, keyword_init: true)

  def initialize(video_relation)
    @video_relation = video_relation
  end

  def leader
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "leader", video_id: @video_relation.select(:id)})
      .group("dancers.name", "dancers.slug")
      .order("count_all DESC", "dancers.name")
      .count
    facet = Facet.new(name: "leader", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: name, value:, count:)
    end

    facet
  end

  def follower
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "follower", video_id: @video_relation.select(:id)})
      .group("dancers.name", "dancers.slug")
      .order("count_all DESC", "dancers.name")
      .count

    facet = Facet.new(name: "follower", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: name, value:, count:)
    end

    facet
  end

  def orchestra
    facet_data = @video_relation
      .joins(song: :orchestra)
      .group("orchestras.name", "orchestras.slug")
      .order("count_all DESC", "orchestras.name")
      .count

    facet = Facet.new(name: "orchestra", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: custom_titleize(name), value:, count:)
    end

    facet
  end

  def genre
    facet_data = @video_relation
      .joins(:song)
      .group("LOWER(songs.genre)")
      .order("count_all DESC", "LOWER(songs.genre)")
      .count

    facet = Facet.new(name: "genre", options: [])
    facet.options = facet_data.map do |value, count|
      Option.new(label: value&.titleize, value:, count:)
    end

    facet
  end

  def year
    facet_data = @video_relation
      .group(:upload_date_year)
      .order("count_all DESC", upload_date_year: :desc)
      .count

    facet = Facet.new(name: "year", options: [])

    facet.options = facet_data.map do |value, count|
      Option.new(label: value, value:, count:)
    end

    facet
  end

  def song
    facet_data = @video_relation
      .joins(:song)
      .group("songs.title", "songs.slug")
      .order("count_all DESC", "songs.title")
      .count

    facet = Facet.new(name: "song", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: name, value:, count:)
    end

    facet
  end

  def event
    facet_data = @video_relation
      .joins(:event)
      .group("events.title", "events.slug")
      .order("count_all DESC", "events.title")
      .count

    facet = Facet.new(name: "event", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: name, value:, count:)
    end

    facet
  end

  private

  def custom_titleize(name)
    name.split("'")&.map(&:titleize)&.join("'")
  end
end
