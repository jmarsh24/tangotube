# frozen_string_literal: true

class Search
  attr_reader :term, :category

  DEFAULT_LIMIT = 5
  Result = Struct.new(:type, :record, :score, keyword_init: true)

  def self.global(query)
    sql = <<-SQL
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
      ORDER BY
        score DESC;
    SQL

    ActiveRecord::Base.connection.exec_query(
      ActiveRecord::Base.sanitize_sql_array([sql, query:])
    )
  end

  def initialize(term:, category: "all")
    @term = term
    @category = allowed_category(category)
  end

  def results
    @results ||=
      if category == "all"
        load_records(Search.global(term))
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
    ["Song", "Channel", "Event", "Orchestra", "Video", "Dancer"]
  end

  def results_for_category
    results = get_results(category).includes(image_attachments(category.to_s))
    results.any? ? map_results(category.to_s.downcase, results.sort_by(&:relevancy).reverse.take(DEFAULT_LIMIT)) : []
  end

  def all_results
    models_with_results = allowed_models.map(&:constantize).flat_map { |model| get_results(model).includes(image_attachments(model.to_s)) }
    results = models_with_results.reject(&:empty?)
    results.any? ? map_results_all(results.flatten) : []
  end

  def get_results(model)
    if term.present?
      model.search(term)
    else
      model.most_popular
    end
  end

  def map_results(category, results)
    results.map { |result| [category, result] }
  end

  def map_results_all(results)
    results.map { |result| [result.class.to_s.downcase, result] }
  end

  def includes_for_type(type)
    case type
    when "events"
      :profile_image_attachment
    when "songs"
      {orchestra: :profile_image_attachment}
    when "orchestras"
      :profile_image_attachment
    when "channels"
      :thumbnail_attachment
    when "videos"
      :thumbnail_attachment
    when "dancers"
      :profile_image_attachment
    else
      []
    end
  end
end
