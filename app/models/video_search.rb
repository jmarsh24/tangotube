# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id                 :bigint           primary key
#  youtube_id               :string
#  upload_date              :date
#  video_description        :string
#  video_description_vector :tsvector
#  dancer_names             :text
#  channel_title            :text
#  song_title               :text
#  song_artist              :text
#  orchestra_name           :text
#  event_city               :text
#  event_title              :text
#  event_country            :text
#  video_title              :text
#
class VideoSearch < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def search(query)
      sanitized_query = ActiveRecord::Base.connection.quote_string(query)
      video_id = VideoSearch.where("'#{sanitized_query}' <% search_text").select(:video_id)

      Video.where(id: video_id).joins(:video_score, :video_search).select("videos.*,
      (0.2 * (1 - (dancer_names <-> '#{query}')) +
      0.2 * (1 - (video_searches.channel_title <-> '#{query}')) +
      0.2 * (1 - (video_searches.song_title <-> '#{query}')) +
      0.1 * (1 - (video_searches.song_artist <-> '#{query}')) +
      0.05 * (1 - (video_searches.orchestra_name <-> '#{query}')) +
      0.05 * (1 - (video_searches.event_city <-> '#{query}')) +
      0.05 * (1 - (video_searches.event_title <-> '#{query}')) +
      0.05 * (1 - (video_searches.event_country <-> '#{query}')) +
      0.2 * (1 - (video_searches.video_title <-> '#{query}')) +
      0.1 * CAST((video_description_vector @@ plainto_tsquery('#{query}')) AS INTEGER)) +
      1.0 * video_scores.score_1 AS total_score
      ").order("total_score DESC")
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end
  end

  def readonly?
    true
  end
end
