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
#  score                    :float
#
class VideoSearch < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def subquery(term)
      sanitized_term = ActiveRecord::Base.connection.quote_string(term)
      select(
        "video_searches.video_id",
        "(0.2 * (1 - (dancer_names <-> '#{sanitized_term}')) +
      0.2 * (1 - (video_searches.channel_title <-> '#{sanitized_term}')) +
      0.2 * (1 - (video_searches.song_title <-> '#{sanitized_term}')) +
      0.1 * (1 - (video_searches.song_artist <-> '#{sanitized_term}')) +
      0.05 * (1 - (video_searches.orchestra_name <-> '#{sanitized_term}')) +
      0.05 * (1 - (video_searches.event_city <-> '#{sanitized_term}')) +
      0.05 * (1 - (video_searches.event_title <-> '#{sanitized_term}')) +
      0.05 * (1 - (video_searches.event_country <-> '#{sanitized_term}')) +
      0.2 * (1 - (video_searches.video_title <-> '#{sanitized_term}')) +
      0.02 * CAST((video_description_vector @@ plainto_tsquery('#{sanitized_term}')) AS INTEGER)) +
      0.5 * video_scores.score_1 AS total_score"
      )
        .joins("INNER JOIN video_scores ON video_scores.video_id = video_searches.video_id")
        .where("'#{sanitized_term}' % dancer_names OR
     '#{sanitized_term}' % video_searches.channel_title OR
     '#{sanitized_term}' % video_searches.song_title OR
     '#{sanitized_term}' % video_searches.song_artist OR
     '#{sanitized_term}' % video_searches.orchestra_name OR
     '#{sanitized_term}' % video_searches.event_city OR
     '#{sanitized_term}' % video_searches.event_title OR
     '#{sanitized_term}' % video_searches.event_country OR
     '#{sanitized_term}' % video_searches.video_title OR
     video_description_vector @@ plainto_tsquery('#{sanitized_term}')")
    end

    def search(term)
      Video.not_hidden.from_active_channels.joins("INNER JOIN (#{subquery(term).to_sql}) AS subquery ON videos.id = subquery.video_id")
        .order("subquery.total_score DESC")
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end
  end

  def readonly?
    true
  end
end
