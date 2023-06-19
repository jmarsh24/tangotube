class Search
  attr_reader :term, :category

  MODELS = {
    "songs" => Song,
    "channels" => Channel,
    # "dancers" => Dancer,
    "events" => Event,
    "orchestra" => Orchestra,
    "videos" => Video
  }.freeze

  TOP_LIMIT = 1
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
      MODELS[category].searched(term)
    elsif category == "top"
      top_results
    else
      all_results
    end
  end

  def top_results
    MODELS.values.flat_map { |model| model.searched(term).limit(TOP_LIMIT) }
  end

  def all_results
    MODELS.values.flat_map { |model| model.searched(term).limit(DEFAULT_LIMIT) }
  end
end
