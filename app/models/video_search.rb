class VideoSearch < ApplicationRecord
  STOP_WORDS = {
    en: ["a", "an", "and", "are", "as", "at", "be", "but", "by", "for", "if", "in", "into", "is", "it", "no", "not", "of", "on", "or", "such", "that", "the", "their", "then", "there", "these", "they", "this", "to", "was", "will", "with"],
    es: ["un", "una", "unos", "unas", "y", "o", "pero", "por", "para", "como", "al", "de", "del", "los", "las"]
  }.freeze

  self.primary_key = :video_id
  belongs_to :video

  class << self
    def search(terms)
      video_searches = Array.wrap(terms)
        .map { |term| remove_stop_words(term) }
        .reduce(self) do |scope, term|
        normalized_term = TextNormalizer.normalize(term)
        quoted_term = ActiveRecord::Base.connection.quote_string(normalized_term)

        upload_date_score = "(1 - ((EXTRACT(EPOCH FROM current_date) - EXTRACT(EPOCH FROM upload_date)) / ((SELECT EXTRACT(EPOCH FROM MAX(upload_date)) FROM video_searches) - (SELECT EXTRACT(EPOCH FROM MIN(upload_date)) FROM video_searches)))) * 0.4"
        click_count_factor = "click_count::float / (SELECT MAX(click_count)::float FROM video_searches) * 0.5"
        dancers_similarity = "similarity(dancers_names, '#{quoted_term}') * 0.35"
        channels_similarity = "similarity(channels_title, '#{quoted_term}') * 0.05"
        songs_similarity = "similarity(songs_title, '#{quoted_term}') * 0.25"
        artist_similarity = "similarity(songs_artist, '#{quoted_term}') * 0.05"
        orchestras_similarity = "similarity(orchestras_name, '#{quoted_term}') * 0.15"
        events_city_similarity = "similarity(events_city, '#{quoted_term}') * 0.05"
        events_title_similarity = "similarity(events_title, '#{quoted_term}') * 0.1"
        events_country_similarity = "similarity(events_country, '#{quoted_term}') * 0.05"
        videos_similarity = "similarity(videos_title, '#{quoted_term}') * 0.15"

        total_score = "(#{upload_date_score} + #{click_count_factor} + #{dancers_similarity} + #{channels_similarity} + #{songs_similarity} + #{artist_similarity} + #{orchestras_similarity} + #{events_city_similarity} + #{events_title_similarity} + #{events_country_similarity} + #{videos_similarity}) as score"

        scope.select("video_id, click_count, #{total_score}")
          .where("? % dancers_names OR ? % channels_title OR ? % songs_title OR ? % songs_artist OR ? % orchestras_name OR ? % events_city OR ? % events_title OR ? % events_country OR ? % videos_title", quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term)
          .order("score DESC")
      end

      video_searches.map(&:video_id)
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end

    def remove_stop_words(term)
      languages = [:en, :es]
      stop_words = languages.map { |language| STOP_WORDS[language] }.compact.flatten
      return term unless stop_words

      term.split.reject { |word| stop_words.include?(word) }.join(" ")
    end
  end

  def refresh_video_search
    VideoSearch.refresh
  end

  def readonly?
    true
  end
end
