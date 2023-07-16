# frozen_string_literal: true

class VideoSearch < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def search(term)
      normalized_term = TextNormalizer.normalize(term)
      quoted_term = ActiveRecord::Base.connection.quote_string(normalized_term)

      upload_date_score = "(1 - ((EXTRACT(EPOCH FROM current_date) - EXTRACT(EPOCH FROM upload_date)) / ((SELECT EXTRACT(EPOCH FROM MAX(upload_date)) FROM video_searches) - (SELECT EXTRACT(EPOCH FROM MIN(upload_date)) FROM video_searches)))) * 0.4"
      click_count_factor = "click_count::float / (SELECT MAX(click_count)::float FROM video_searches) * 0.5"
      dancers_similarity = "similarity(dancer_names, '#{quoted_term}') * 0.35"
      channels_similarity = "similarity(channel_title, '#{quoted_term}') * 0.05"
      songs_similarity = "similarity(song_title, '#{quoted_term}') * 0.25"
      artist_similarity = "similarity(song_artist, '#{quoted_term}') * 0.05"
      orchestras_similarity = "similarity(orchestra_name, '#{quoted_term}') * 0.15"
      events_city_similarity = "similarity(event_city, '#{quoted_term}') * 0.05"
      events_title_similarity = "similarity(event_title, '#{quoted_term}') * 0.1"
      events_country_similarity = "similarity(event_country, '#{quoted_term}') * 0.05"
      videos_similarity = "similarity(video_title, '#{quoted_term}') * 0.15"

      total_score = "(#{upload_date_score} + #{click_count_factor} + #{dancers_similarity} + #{channels_similarity} + #{songs_similarity} + #{artist_similarity} + #{orchestras_similarity} + #{events_city_similarity} + #{events_title_similarity} + #{events_country_similarity} + #{videos_similarity}) as score"

      video_searches = self
        .select("video_id, #{total_score}")
        .where("? % dancer_names OR ? % channel_title OR ? % song_title OR ? % song_artist OR ? % orchestra_name OR ? % event_city OR ? % event_title OR ? % event_country OR ? % video_title", quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term)
        .order("score DESC")

      video_searches.map(&:video_id)
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end
  end

  def refresh_video_search
    VideoSearch.refresh
  end

  def readonly?
    true
  end
end
