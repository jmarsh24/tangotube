# frozen_string_literal: true

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

  def initialize(term:, category: "all")
    @term = term
    @category = category
  end

  def results
    @results ||=
      if category == "all"
        all_results
      elsif MODELS.key?(category)
        results_for_category(category)
      else
        []
      end
  end

  private

  def results_for_category(category)
    results = get_results(MODELS[category])
    results.any? ? group_by_model(results.limit(DEFAULT_LIMIT)) : []
  end

  def all_results
    group_by_model(results_for_all_models(DEFAULT_LIMIT))
  end

  def results_for_all_models(limit)
    models_with_results = MODELS.values.flat_map { |model| get_results(model).limit(limit) }
    models_with_results.any? ? models_with_results : []
  end

  def get_results(model)
    if term.present?
      model.search(term)
    elsif model.respond_to?(:most_popular)
      model.most_popular
    else
      model.none
    end
  end

  def group_by_model(results)
    results.group_by { |result| result.class.name }
  end
end
