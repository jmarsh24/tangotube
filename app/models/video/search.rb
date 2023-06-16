# frozen_string_literal: true

class Video::Search
  attr_reader :filtering_params, :sorting_params
  attr_accessor :user

  def initialize(filtering_params:, sorting_params: {sort: "popularity", direction: "desc"}, hidden: false, user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @user = user
    @hidden = hidden
  end

  def videos
    filtered_videos = Video::Filter.new(Video.all.includes(Video.search_includes), filtering_params:, user:).filtered_videos
    Video::Sort.new(filtered_videos, sorting_params:).sorted_videos
  end

  def featured_videos
    Video.includes(Video.search_includes).where(featured: true).order("RANDOM()")
  end

  def facet(name:)
    videos = Video::Filter.new(Video.all, filtering_params:, user:).filtered_videos
    Video::FacetBuilder.new(videos).public_send(name)
  end
end
