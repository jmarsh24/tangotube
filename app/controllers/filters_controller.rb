class FiltersController < ApplicationController
  before_action :videos_search

  def filters
    genre
    leader
    follower
    orchestra
    year
  end

  private

  def videos_search
    @videos_search = Rails.cache.fetch("videos_search", expired_in: 12.hours) do
      Video.search(query_params.presence || "*",
      where: filtering_params,
      aggs: [:genre, :leader, :follower, :orchestra, :year],
      misspellings: {edit_distance: 10})
    end
  end

  def genre
    @genres ||= @videos_search.aggs["genre"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def leader
    @leaders ||= @videos_search.aggs["leader"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def follower
    @followers ||= @videos_search.aggs["follower"]["buckets"]
                                .sort_by{ |b| b["doc_count"] }
                                .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def orchestra
    @orchestras ||= @videos_search.aggs["orchestra"]["buckets"]
                                  .sort_by{ |b| b["doc_count"] }
                                  .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def year
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
                  :song_id,
                  :hd,
                  :event_id,
                  :year,
                  :watched,
                  :liked,
                  :id,
                  :query,
                  :dancer)
  end
end
