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
    sql =
      <<~SQL
                (
        	SELECT
        		'channels' AS record_type,
        		id AS record_id,
        		(similarity (title,
        				:query) * 10000 * 0.4 + videos_count / 1000 * 0.2) AS score
        	FROM
        		channels
        	WHERE
        		:query % title)
        UNION (
        	SELECT
        		'dancers' AS record_type,
        		id AS record_id,
        		(similarity (name,
        				:query) * 10000 * 0.4 + videos_count / 1000 * 0.2) AS score
        	FROM
        		dancers
        	WHERE
        		:query % name)
        UNION (
        	SELECT
        		'events' AS record_type,
        		id AS record_id,
        		(similarity (title,
        				:query) * 10000 + similarity (city,
        				:query) * 0.3 + similarity (country,
        				:query) * 0.3 + videos_count / 1000 * 0.2) AS score
        	FROM
        		events
        	WHERE
        		:query % title
        		OR :query % city
        		OR :query % country)
        UNION (
        	SELECT
        		'orchestras' AS record_type,
        		id AS record_id,
        		(similarity (name,
        				:query) * 10000 + videos_count / 1000 * 0.2) AS score
        	FROM
        		orchestras
        	WHERE
        		:query % name)
        UNION (
        	SELECT
        		'songs' AS record_type,
        		id AS record_id,
        		(similarity (title,
        				:query) * 10000 + similarity (artist,
        				:query) * 10000 + similarity (genre,
        				:query) * 0.1 + videos_count / 1000 * 0.2) AS score
        	FROM
        		songs
        	WHERE
        		:query % title
        		OR :query % artist
        		OR :query % genre)
        UNION (
        	SELECT
        		'videos' AS record_type,
        		video_id AS record_id,
        		score
        	FROM
        		video_searches
        	WHERE
        		:query % dancer_names
        		OR :query % channel_title
        		OR :query % song_title
        		OR :query % song_artist
        		OR :query % orchestra_name
        		OR :query % event_city
        		OR :query % event_title
        		OR :query % event_country
        		OR :query % video_title)
        ORDER BY
        	score DESC
        LIMIT 100;
      SQL

    ActiveRecord::Base.connection.exec_query(
      ActiveRecord::Base.sanitize_sql_array([sql, query:])
    )
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
