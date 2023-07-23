# frozen_string_literal: true

class Search
  Result = Struct.new(:type, :record, :score, keyword_init: true)

  DEFAULT_LIMIT = 50

  attr_reader :query, :category

  def initialize(query:, category: "all")
    @query = query
    @category = allowed_category(category)
  end

  def results
    return most_popular_results if query.blank? && category == "all"

    if category == "all" && query.present?
      load_records(Search.global(query))
    else
      results_for_category
    end
  end

  def self.global(query)
    terms = query.split(" ")
    sql = terms.flat_map do |term|
      ActiveRecord::Base.sanitize_sql_array([
        <<~SQL, query: term
          (
            SELECT
              'channels' AS record_type,
              id AS record_id,
              (similarity (title, :query) * 0.5 + (videos_count::float / (SELECT MAX(videos_count)::float FROM channels)) * 0.5) AS score
            FROM
              channels
            WHERE
              :query % title)
          UNION ALL
          (
            SELECT
              'dancers' AS record_type,
              id AS record_id,
              (similarity (name, :query) * 0.5 + (videos_count::float / (SELECT MAX(videos_count)::float FROM dancers)) * 0.5) AS score
            FROM
              dancers
            WHERE
              :query % name)
          UNION ALL
          (
            SELECT
              'events' AS record_type,
              id AS record_id,
              (similarity (title, :query) + similarity (city, :query) * 0.33 + similarity (country, :query) * 0.33 + (videos_count::float / (SELECT MAX(videos_count)::float FROM events)) * 0.33) AS score
            FROM
              events
            WHERE
              :query % title OR :query % city OR :query % country)
          UNION ALL
          (
            SELECT
              'orchestras' AS record_type,
              id AS record_id,
              (similarity (name, :query) * 0.5 + (videos_count::float / (SELECT MAX(videos_count)::float FROM orchestras)) * 0.5) AS score
            FROM
              orchestras
            WHERE
              :query % name)
          UNION ALL
          (
            SELECT
              'songs' AS record_type,
              id AS record_id,
              (similarity (title, :query) * 0.6 + similarity (artist, :query) * 0.1 + similarity (genre, :query) * 0.1 + (videos_count::float / (SELECT MAX(videos_count)::float FROM songs)) * 0.2) AS score
            FROM
              songs
            WHERE
              :query % title OR :query % artist OR :query % genre)
          UNION ALL
          (
            SELECT
              'videos' AS record_type,
              video_id AS record_id,
              (score * 0.3) AS score
            FROM
              video_searches
            WHERE
              :query % dancer_names OR :query % channel_title OR :query % song_title OR :query % song_artist OR :query % orchestra_name OR :query % event_city OR :query % event_title OR :query % event_country OR :query % video_title)
        SQL
      ])
    end.join(" UNION ALL ")

    sql << " ORDER BY score DESC LIMIT 100;"
    ActiveRecord::Base.connection.exec_query(sql)
  end

  private

  def load_records(records)
    records_grouped_by_type = records.group_by { |record| record["record_type"] }

    results = []
    records_grouped_by_type.each do |type, records|
      klass = type.singularize.classify.constantize
      type = type.pluralize.downcase
      ids = records.map { |record| record["record_id"] }

      loaded_records = klass.includes(includes_for_type(type)).where(id: ids)

      records.each do |record|
        loaded_record = loaded_records.find { |lr| lr.id == record["record_id"] }
        next unless loaded_record

        score = record["score"]
        result = Result.new(type:, record: loaded_record, score:)
        results << result
      end
    end

    results
  end

  def allowed_category(category)
    if allowed_models.include?(category.downcase)
      category.downcase.camelize.constantize
    else
      "all"
    end
  end

  def allowed_models
    ["song", "channel", "event", "orchestra", "video", "dancer"]
  end

  def results_for_category
    model = category.to_s.classify.constantize
    type = category.to_s.pluralize.downcase
    includes = includes_for_type(type)

    results = query.present? ? model.includes(includes).search(query) : model.includes(includes).most_popular
    if results.any?
      results = results.take(DEFAULT_LIMIT)
      results.map do |record|
        score = record.try(:score) || 0
        Result.new(type:, record:, score:)
      end
    else
      []
    end
  end

  def most_popular_results
    results = allowed_models.map { |m| m.singularize.camelize.constantize }.flat_map do |model|
      next unless model.respond_to?(:most_popular)
      type = model.to_s.pluralize.downcase
      model.most_popular.includes(includes_for_type(type)).take(DEFAULT_LIMIT).map do |record|
        Result.new(type:, record:, score: nil)
      end
    end.flatten
    results.shuffle
  end

  def includes_for_type(type)
    case type
    when "events"
      {profile_image_attachment: :blob}
    when "songs"
      {orchestra: {profile_image_attachment: :blob}}
    when "orchestras"
      {profile_image_attachment: :blob}
    when "channels", "videos"
      {thumbnail_attachment: :blob}
    when "dancers"
      {profile_image_attachment: :blob}
    else
      []
    end
  end
end
