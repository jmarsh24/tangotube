# frozen_string_literal: true

class Video::FacetBuilder
  Facet = Struct.new(:name, :options, keyword_init: true)
  Option = Struct.new(:value, :label, keyword_init: true)

  def initialize(video_relation)
    @video_relation = video_relation
  end

  def leaders
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "leader", video_id: @video_relation.select(:id)})
      .group("dancers.name", "dancers.slug")
      .order("count_all DESC", "dancers.name")
      .count
    facet = Facet.new(name: "leader", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: "#{name} (#{count})", value:)
    end

    facet
  end

  def followers
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "follower", video_id: @video_relation.select(:id)})
      .group("dancers.name", "dancers.slug")
      .order("count_all DESC", "dancers.name")
      .count

    facet = Facet.new(name: "follower", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: "#{name} (#{count})", value:)
    end

    facet
  end

  def orchestras
    facet_data = @video_relation
      .joins(song: :orchestra)
      .group("orchestras.name", "orchestras.slug")
      .order("count_all DESC", "orchestras.name")
      .count

    facet = Facet.new(name: "orchestra", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: "#{custom_titleize(name)} (#{count})", value:)
    end

    facet
  end

  def genres
    facet_data = @video_relation
      .joins(:song)
      .group("LOWER(songs.genre)")
      .order("count_all DESC", "LOWER(songs.genre)")
      .count

    facet = Facet.new(name: "genre", options: [])
    facet.options = facet_data.map do |value, count|
      Option.new(label: "#{value&.titleize} (#{count})", value:)
    end

    facet
  end

  def years
    facet_data = @video_relation
      .group(:upload_date_year)
      .order("count_all DESC", upload_date_year: :desc)
      .count

    facet = Facet.new(name: "year", options: [])

    facet.options = facet_data.map do |value, count|
      Option.new(label: "#{value} (#{count})", value:)
    end

    facet
  end

  def songs
    facet_data = @video_relation
      .joins(:song)
      .group("songs.title", "songs.slug")
      .order("count_all DESC", "songs.title")
      .count

    facet = Facet.new(name: "song", options: [])
    facet.options = facet_data.map do |(name, value), count|
      Option.new(label: "#{name} (#{count})", value:)
    end

    facet
  end

  private

  def custom_titleize(name)
    name.split("'")&.map(&:titleize)&.join("'")
  end
end
