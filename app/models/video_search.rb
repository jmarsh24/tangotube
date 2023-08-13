# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id       :bigint
#  youtube_id     :string
#  upload_date    :date
#  dancer_names   :text
#  channel_title  :text
#  song_title     :text
#  song_artist    :text
#  orchestra_name :text
#  event_city     :text
#  event_title    :text
#  event_country  :text
#  video_title    :text
#  score          :float
#
class VideoSearch < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def subquery(term)
      sanitized_term = ActiveRecord::Base.connection.quote_string(term)
      select(
        "video_searches.video_id",
        "(0.2 * (dancer_names <-> '#{sanitized_term}') +
      0.2 * (channel_title <-> '#{sanitized_term}') +
      0.2 * (song_title <-> '#{sanitized_term}') +
      0.2 * (song_artist <-> '#{sanitized_term}') +
      0.2 * (orchestra_name <-> '#{sanitized_term}') +
      0.2 * (event_city <-> '#{sanitized_term}') +
      0.2 * (event_title <-> '#{sanitized_term}') +
      0.2 * (event_country <-> '#{sanitized_term}') +
      0.2 * (video_title <-> '#{sanitized_term}') +
      0.2 * CAST((video_description_vector @@ plainto_tsquery('#{sanitized_term}')) AS INTEGER)) +
      3.0 * video_scores.score_1 AS total_score"
      )
        .joins("INNER JOIN video_scores ON video_scores.video_id = video_searches.video_id")
        .where("'#{sanitized_term}' % dancer_names OR
     '#{sanitized_term}' % channel_title OR
     '#{sanitized_term}' % song_title OR
     '#{sanitized_term}' % song_artist OR
     '#{sanitized_term}' % orchestra_name OR
     '#{sanitized_term}' % event_city OR
     '#{sanitized_term}' % event_title OR
     '#{sanitized_term}' % event_country OR
     '#{sanitized_term}' <% video_title OR
     video_description_vector @@ plainto_tsquery('#{sanitized_term}')")
    end

    def search(term)
      Video.joins("INNER JOIN (#{subquery(term).to_sql}) AS subquery ON videos.id = subquery.video_id")
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
