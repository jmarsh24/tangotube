# frozen_string_literal: true

class Search
  attr_reader :query, :category

  DEFAULT_LIMIT = 50
  Result = Struct.new(:type, :record, :score, keyword_init: true)

  def self.global(query)
    sql =
      <<~SQL
        WITH min_max_dates AS (
          SELECT 
            EXTRACT(EPOCH FROM MIN(upload_date)) as min_date,
            EXTRACT(EPOCH FROM MAX(upload_date)) as max_date
          FROM videos
        )
                    (
                SELECT
                  'channels' AS record_type,
                  id AS record_id,
                  (similarity (title, :query) * 0.4  * 0.4 + videos_count / 1000 * 0.2) AS score
                FROM
                  channels
                WHERE
                  :query % title
              )
              UNION 
              (
                SELECT
                  'dancers' AS record_type,
                  id AS record_id,
                  (similarity (name, :query) * 0.4  * 0.4 + videos_count / 1000 * 0.2) AS score
                FROM
                  dancers
                WHERE
                  :query % name
              )
              UNION 
              (
                SELECT
                  'events' AS record_type,
                  id AS record_id,
                  (similarity (title, :query) * 0.4 + similarity (city, :query) * 0.3 + similarity (country, :query) * 0.3 + videos_count / 1000 * 0.2) AS score
                FROM
                  events
                WHERE
                  :query % title
                  OR :query % city
                  OR :query % country
              )
              UNION 
              (
                SELECT
                  'orchestras' AS record_type,
                  id AS record_id,
                  (similarity (name, :query) * 0.4 * 0.4 + videos_count / 1000 * 0.2) AS score
                FROM
                  orchestras
                WHERE
                  :query % name
              )
              UNION 
              (
                SELECT
                  'songs' AS record_type,
                  id AS record_id,
                  (similarity (title, :query) * 0.4 + similarity (artist, :query) * 0.3 + similarity (genre, :query) * 0.1 + videos_count / 1000 * 0.2) AS score
                FROM
                  songs
                WHERE
                  :query % title
                  OR :query % artist
                  OR :query % genre
              )
              UNION 
        (
          SELECT
            'videos' AS record_type,
            video_id AS record_id,
            (
              (1 - ((EXTRACT(EPOCH FROM current_date) - EXTRACT(EPOCH FROM upload_date)) / ((SELECT max_date FROM min_max_dates) - (SELECT min_date FROM min_max_dates)))) * 0.4 +
              click_count::float / (SELECT MAX(click_count)::float FROM video_searches) * 0.2 +
              similarity(dancers_names, :query) * 0.35 +
              similarity(channels_title, :query) * 0.05 +
              similarity(songs_title, :query) * 0.25 +
              similarity(songs_artist, :query) * 0.05 +
              similarity(orchestras_name, :query) * 0.15 +
              similarity(events_city, :query) * 0.05 +
              similarity(events_title, :query) * 0.1 +
              similarity(events_country, :query) * 0.05 +
              similarity(videos_title, :query) * 0.15
            ) AS score 
          FROM 
            video_searches 
          WHERE 
            :query % dancers_names OR
            :query % channels_title OR
            :query % songs_title OR
            :query % songs_artist OR
            :query % orchestras_name OR
            :query % events_city OR
            :query % events_title OR
            :query % events_country OR
            :query % videos_title 
        )
        ORDER BY
          score DESC
        LIMIT 100;
      SQL

    ActiveRecord::Base.connection.exec_query(
      ActiveRecord::Base.sanitize_sql_array([sql, query:])
    )
  end

  def initialize(query:, category: "all")
    @query = query
    @category = allowed_category(category)
  end

  def results
    return most_popular_results if query.blank?

    @results ||=
      if category == "all" && query.present?
        load_records(Search.global(query))
      else
        results_for_category
      end
  end

  private

  def load_records(records)
    records_grouped_by_type = records.group_by { |record| record["record_type"] }

    results = []
    records_grouped_by_type.each do |type, records|
      klass = type.singularize.classify.constantize

      ids = records.map { |record| record["record_id"] }

      includes = includes_for_type(type)

      loaded_records = klass.includes(includes).where(id: ids)

      records.each do |record|
        loaded_record = loaded_records.find { |lr| lr.id == record["record_id"] }
        next unless loaded_record

        score = record["score"]
        result = Result.new(type: type.singularize, record: loaded_record, score:)
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
    includes = includes_for_type(category.to_s)

    results = query.present? ? model.search(query).includes(includes) : model.most_popular.includes(includes)
    if results.any?
      results = results.take(DEFAULT_LIMIT)
      results.map do |record|
        score = record.try(:score) || 0
        Result.new(type: category.to_s.downcase.singularize, record:, score:)
      end
    elsif model.respond_to?(:most_popular)
      model.most_popular.includes(includes)
    else
      []
    end
  end

  def most_popular_results
    allowed_models.map { |m| m.singularize.camelize.constantize }.flat_map do |model|
      next unless model.respond_to?(:most_popular)
      model.most_popular.includes(includes_for_type(model.to_s)).take(DEFAULT_LIMIT).map do |record|
        Result.new(type: model.to_s.downcase.singularize, record:, score: nil)
      end
    end.flatten
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
