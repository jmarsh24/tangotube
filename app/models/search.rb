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
          OR 'sarli' % title
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
          OR 'sarli' % name
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
          OR 'sarli' % name
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
    results = []
    records.each do |record|
      type = record["record_type"].singularize
      id = record["record_id"]
      score = record["score"]

      # Load the record of this type if it hasn't been loaded yet
      loaded_record = type.classify.constantize.find_by(id:)
      next unless loaded_record

      # Create a result struct and add it to the results array
      result = Result.new(type:, record: loaded_record, score:)
      results << result
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

  def image_attachments(model_name)
    case model_name
    when "Event"
      :profile_image_attachment
    when "Song"
      {orchestra: :profile_image_attachment}
    when "Orchestra"
      :profile_image_attachment
    when "Channel"
      :thumbnail_attachment
    when "Video"
      :thumbnail_attachment
    when "Dancer"
      :profile_image_attachment
    else
      []
    end
  end
end
