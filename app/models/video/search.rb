class Video::Search
  attr_reader :filtering_params, :sorting_params
  attr_accessor :current_user

  def initialize(filtering_params: {hidden: false}, sorting_params: {sort: "popularity", direction: "desc"}, hidden: false, user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @current_user = current_user
    @hidden = hidden
  end

  def videos
    filtered_videos = Video::Filter.new(Video.all, filtering_params:, current_user:).filtered_videos
    Video::Sort.new(filtered_videos, sorting_params:).sorted_videos
  end

  def featured_videos
    Video.where(featured: true).order("RANDOM()")
  end

  def facet(name:)
    videos = Video::Filter.new(Video.all, filtering_params:, current_user:).filtered_videos
    Video::FacetBuilder.new(videos).public_send(name)
  end
end
