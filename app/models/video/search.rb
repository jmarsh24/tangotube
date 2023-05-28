class Video::Search
  attr_reader :filtering_params, :sorting_params

  def initialize(filtering_params: {}, sorting_params: {column: "popularity", direction: "desc"})
    @filtering_params = filtering_params
    @sorting_params = sorting_params
  end

  def perform_search
    filtered_videos = Video::Filter.new(Video.all, filtering_params:).apply_filter
    sorted_videos = Video::Sort.new(filtered_videos, sorting_params: @sorting_params).apply_sort

    facets = generate_facets(filtered_videos)

    [sorted_videos, facets]
  end

  private

  def generate_facets(videos)
    facet_builder = Video::FacetBuilder.new(videos)
    {
      leaders: facet_builder.leaders,
      followers: facet_builder.followers,
      orchestras: facet_builder.orchestras,
      genres: facet_builder.genres,
      years: facet_builder.years,
      songs: facet_builder.songs
    }
  end
end
