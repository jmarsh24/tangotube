# frozen_string_literal: true

class Video::Search
  attr_reader :filtering_params, :sort
  attr_accessor :user

  def initialize(filtering_params: {}, sort: nil, user: nil)
    @filtering_params = filtering_params
    @sort = sort
    @user = user
  end

  def videos
    filtered_videos = Video::Filter.new(Video, filtering_params:, user:).videos
    if sort.present?
      Video::Sort.new(filtered_videos, sort:).videos
    else
      Video::Sort.new(filtered_videos).videos
    end
  end

  def featured_videos
    Video.where(featured: true).order("RANDOM()")
  end

  def facet(name:)
    videos = Video::Filter.new(Video, filtering_params: @filtering_params.except(name.to_sym), user:).videos
    Video::FacetBuilder.new(videos).public_send(name)
  end
end
