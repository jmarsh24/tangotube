class Video::FacetBuilder
  Facet = Struct.new(:name, :count, :param, :value, keyword_init: true)

  def initialize(video_relation)
    @video_relation = video_relation
  end

  def leaders
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "leader", video_id: @video_relation.pluck(:id)})
      .pluck("dancers.name, dancers.slug")

    facet_data.tally.map do |(name, slug), count|
      Facet.new(name:, count:, param: "leader", value: slug)
    end.sort_by { |facet| [-facet.count, facet.name] }
  end

  def followers
    facet_data = Dancer.joins(:dancer_videos)
      .where(dancer_videos: {role: "follower", video_id: @video_relation.pluck(:id)})
      .pluck("dancers.name, dancers.slug")

    facet_data.tally.map do |(name, slug), count|
      Facet.new(name:, count:, param: "follower", value: slug)
    end.sort_by { |facet| [-facet.count, facet.name] }
  end

  def orchestras
    facet_data = @video_relation
      .joins(song: :orchestra)
      .pluck("orchestras.name, orchestras.slug")

    facet_data.tally.map do |(name, slug), count|
      Facet.new(name:, count:, param: "orchestra", value: slug)
    end.sort_by { |facet| [-facet.count, facet.name] }
  end

  def genres
    facet_data = @video_relation
      .joins(:song)
      .pluck("songs.genre")

    facet_data.tally.map do |genre, count|
      Facet.new(name: genre, count:, param: "genre", value: genre.downcase)
    end.sort_by { |facet| [-facet.count, facet.name] }
  end

  def years
    facet_data = @video_relation.pluck(:upload_date_year)

    facet_data.tally.map do |year, count|
      Facet.new(name: year.to_i, count:, param: "year", value: year)
    end.sort_by { |facet| [-facet.count, -facet.name] }
  end

  def songs
    facet_data = @video_relation
      .joins(:song)
      .pluck("songs.title, songs.slug")

    facet_data.tally.map do |(name, slug), count|
      Facet.new(name:, count:, param: "song", value: slug)
    end.sort_by { |facet| [-facet.count, facet.name] }
  end
end
