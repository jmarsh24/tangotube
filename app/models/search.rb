class Search
  attr_reader :term, :category

  MODELS = {
    "songs" => Song,
    "channels" => Channel,
    "events" => Event,
    "orchestra" => Orchestra,
    "videos" => Video,
    "dancers" => Dancer
  }.freeze

  DEFAULT_LIMIT = 5

  def initialize(term:, category: nil)
    @term = term
    @category = category
  end

  def results
    @results ||= search_results
  end

  private

  def search_results
    if category == "all"
      all_results
    elsif MODELS.key?(category)
      results_for_category(category)
    else
      []
    end
  end

  def results_for_category(category)
    results = MODELS[category].search(term)
    results.any? ? results.limit(DEFAULT_LIMIT) : []
  end

  def all_results
    results_for_all_models(DEFAULT_LIMIT).group_by { |result| result.class.name }
  end

  def results_for_all_models(limit)
    models_with_results = MODELS.values.select { |model| model.search(term).any? }
    models_with_results.flat_map { |model| model.search(term).limit(limit) }
  end
end
