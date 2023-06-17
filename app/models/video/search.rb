# frozen_string_literal: true

class Video::Search
  attr_reader :filtering_params, :sorting_params
  attr_accessor :user

  def initialize(filtering_params: {}, sorting_params: {}, user: nil)
    @filtering_params = filtering_params
    @sorting_params = sorting_params
    @user = user
  end

  def videos
    filtered_videos = Video::Filter.new(Video.not_hidden, filtering_params:, user:).filtered_videos
    Video::Sort.new(filtered_videos, sorting_params:).sorted_videos
  end

  def featured_videos
    Video.not_hidden.where(featured: true).order("RANDOM()")
  end

  def facet(name:)
    videos = Video::Filter.new(Video.not_hidden, filtering_params:, user:).filtered_videos
    Video::FacetBuilder.new(videos).public_send(name)
  end
end
