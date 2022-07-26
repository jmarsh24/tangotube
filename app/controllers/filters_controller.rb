class FiltersController < ApplicationController
  before_action :videos_search

  def filters
    genres
    leaders
    followers
    orchestras
    years
  end

  private

  def videos_search
    filter_array = []
    filtering_params.map { |k, v| "#{k} = '#{v}'" }.each do |filter|
      filter_array << filter
    end

    @videos_search =
      Video.search(query_params.presence || "*",
       filter: filter_array,
        facets: ["genre", "leader", "follower", "orchestra", "year"]
       )
  end

  def genres
    @genres =
    @videos_search
    .facets_distribution
    .fetch("genre")
    .sort_by{|_k, v| v}
    .reverse
    .map{ |k,v| ["#{k.titleize} (#{v})", k.parameterize] }
  end

  def leaders
    @leaders =
    @videos_search
    .facets_distribution
    .fetch("leader")
    .sort_by{|_k, v| v}
    .reverse
    .map{ |k,v| ["#{k.titleize} (#{v})", k.parameterize] }
  end

  def followers
    @followers =
    @videos_search
    .facets_distribution
    .fetch("follower")
    .sort_by{|_k, v| v}
    .reverse
    .map{ |k,v| ["#{k.titleize} (#{v})", k.parameterize] }
  end

  def orchestras
    @orchestras =
    @videos_search
    .facets_distribution
    .fetch("orchestra")
    .sort_by{|_k, v| v}
    .reverse
    .map{ |k,v| ["#{k.titleize} (#{v})", k.parameterize] }
  end

  def years
    @years =
    @videos_search
    .facets_distribution
    .fetch("year")
    .sort_by{|_k, v| v}
    .reverse
    .map{ |k,v| ["#{k.titleize} (#{v})", k.parameterize] }
  end

  def filtering_params
    permitted_params.except(:query, :liked, :watched).to_h
  end

  def query_params
    permitted_params.slice(:query)[:query]
  end

  def permitted_params
    params.permit(:leader,
                  :follower,
                  :channel,
                  :genre,
                  :orchestra,
                  :song,
                  :hd,
                  :event,
                  :year,
                  :watched,
                  :liked,
                  :id,
                  :query,
                  :dancer)
  end
end
