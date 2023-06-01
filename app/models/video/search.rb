class Video::Search
  attr_reader :filtering_params, :sorting_params, :current_user

  Facets = Struct.new(:leaders, :followers, :orchestras, :genres, :years, :songs, keyword_init: true)

  def initialize(filtering_params: {hidden: false}, sorting_params: {sort: "popularity", direction: "desc"}, hidden: false, current_user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @current_user = current_user
    @hidden = hidden
  end

  def videos
    filtered_videos = Video::Filter.new(Video.all, filtering_params:, current_user:).apply_filter
    Video::Sort.new(filtered_videos, sorting_params:).apply_sort
  end

  def featured_videos
    Video.where(featured: true).order("RANDOM()")
  end

  def facets
    videos = Video::Filter.new(Video.all, filtering_params:, current_user:).apply_filter
    facet_builder = Video::FacetBuilder.new(videos)

    Facets.new(
      leaders: facet_builder.leaders,
      followers: facet_builder.followers,
      orchestras: facet_builder.orchestras,
      genres: facet_builder.genres,
      years: facet_builder.years,
      songs: facet_builder.songs
    )
  end
end
