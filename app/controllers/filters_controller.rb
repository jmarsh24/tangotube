class FiltersController < ApplicationController
  before_action :video_search

  def genre
    @genres ||= @video_search.aggs["genre"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def leader
    @leaders ||= @video_search.aggs["leader"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def follower
    @followers ||= @video_search.aggs["follower"]["buckets"]
                                .sort_by{ |b| b["doc_count"] }
                                .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def orchestra
    @orchestras ||= @video_search.aggs["orchestra"]["buckets"]
                                  .sort_by{ |b| b["doc_count"] }
                                  .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  def year
    @years ||= @video_search.aggs["year"]["buckets"]
                            .sort_by{ |b| b["key"] }
                            .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
  end

  private

  def video_search
    @video_search ||= Video.search(query_params.presence || "*",
      where: filtering_params,
      aggs: [:genre, :leader, :follower, :orchestra, :year],
      misspellings: {edit_distance: 10})
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
