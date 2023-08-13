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
    sql = ActiveRecord::Base.sanitize_sql_array([
      <<~SQL, query:
        WITH FilteredResults AS (
          -- Channels
          SELECT 'channels' AS record_type, id AS record_id, title, videos_count
          FROM channels WHERE title % :query
          UNION ALL
          -- Dancers
          SELECT 'dancers', id, name AS title, videos_count
          FROM dancers WHERE name % :query
          UNION ALL
          -- Events
          SELECT 'events', id, title, videos_count
          FROM events WHERE title % :query OR city % :query OR country % :query
          UNION ALL
          -- Orchestras
          SELECT 'orchestras', id, name AS title, videos_count
          FROM orchestras WHERE name % :query
          UNION ALL
          -- Songs
          SELECT 'songs', id, title, videos_count
          FROM songs WHERE title % :query OR artist % :query OR genre % :query
          UNION ALL
          -- Couples
          SELECT 'couples', couples.id, (d1.name || ' ' || d2.name) AS title, couples.videos_count
          FROM couples
          JOIN dancers d1 ON couples.dancer_id = d1.id
          JOIN dancers d2 ON couples.partner_id = d2.id
          WHERE d1.name % :query OR d2.name % :query
        )

        SELECT 
          record_type, 
          record_id, 
          CASE
            WHEN record_type = 'channels' THEN ((1 - (title <-> :query)) * 0.2 + (videos_count::float / (SELECT MAX(videos_count)::float FROM channels)) * 0.8)
            WHEN record_type = 'dancers' THEN ((1 - (title <-> :query)) * 0.2 + (videos_count::float / (SELECT MAX(videos_count)::float FROM dancers)) * 0.8)
            WHEN record_type = 'events' THEN ((1 - (title <<-> :query)) * 0.05 + (1 - (title <<-> :query)) * 0.05 + (1 - (title <<-> :query)) * 0.05 + (videos_count::float / (SELECT MAX(videos_count)::float FROM events)) * 0.85)
            WHEN record_type = 'orchestras' THEN ((1 - (title <<-> :query)) * 0.2 + (videos_count::float / (SELECT MAX(videos_count)::float FROM orchestras)) * 0.8)
            WHEN record_type = 'songs' THEN ((1 - (title <<-> :query)) * 0.05 + (1 - (title <<-> :query)) * 0.05 + (1 - (title <<-> :query)) * 0.05 + (videos_count::float / (SELECT MAX(videos_count)::float FROM songs)) * 0.7)
            WHEN record_type = 'couples' THEN ((1 - (title <<-> :query)) * 0.4 + (videos_count::float / (SELECT MAX(videos_count)::float FROM couples)) * 0.6)
          END AS score
        FROM FilteredResults
        UNION ALL
        (
          SELECT 
            'videos' AS record_type, 
            vs.video_id AS record_id, 
            (vscore.score_1 * 0.8) AS score
          FROM video_searches vs
          JOIN video_scores vscore ON vs.video_id = vscore.video_id
          WHERE vs.dancer_names % :query OR vs.channel_title % :query OR vs.song_title % :query OR vs.song_artist % :query OR vs.orchestra_name % :query OR vs.event_city % :query OR vs.event_title % :query OR vs.event_country % :query OR vs.video_title % :query
        )
        ORDER BY score DESC LIMIT 100
      SQL
    ])

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
