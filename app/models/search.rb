class Search
  attr_reader :term, :category

  MODELS = {
    "songs" => Song,
    "channels" => Channel,
    "events" => Event,
    "orchestra" => Orchestra,
    "videos" => Video
  }.freeze

  DEFAULT_LIMIT = 3

  def initialize(term:, category: nil)
    @term = term
    @category = category
  end

  def results
    @results ||= search_results
  end

  private

  def search_results
    if MODELS.key?(category)
      results_for_category(category)
    else
      all_results
    end
  end

  def results_for_category(category)
    results = MODELS[category].searched(term)
    results.any? ? results.limit(DEFAULT_LIMIT) : []
  end

  def all_results
    results_for_all_models(DEFAULT_LIMIT)
  end

  def results_for_all_models(limit)
    models_with_results = MODELS.values.select { |model| model.searched(term).any? }
    models_with_results.flat_map { |model| model.searched(term).limit(limit) }
  end
end
