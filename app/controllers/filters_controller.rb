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
    @videos_search =
      Video.search(query_params.presence || "*",
      where: filtering_params,
      aggs: [:genre, :leader, :follower, :orchestra, :year],
      misspellings: {edit_distance: 10})
  end

  def genres
    @genres ||= @videos_search.aggs["genre"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def leaders
    @leaders ||= @videos_search.aggs["leader"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def followers
    @followers ||= @videos_search.aggs["follower"]["buckets"]
                                .sort_by{ |b| b["doc_count"] }
                                .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def orchestras
    @orchestras ||= @videos_search.aggs["orchestra"]["buckets"]
                                  .sort_by{ |b| b["doc_count"] }
                                  .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def years
    @years ||= @videos_search.aggs["year"]["buckets"]
                            .sort_by{ |b| b["key"] }
                            .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def filtering_params
    permitted_params.except(:query, :liked, :watched).to_h
  end

  def query_params
    permitted_params.slice(:query).to_h
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
