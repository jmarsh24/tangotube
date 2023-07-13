# frozen_string_literal: true

class Search
  attr_reader :term, :category

  MODELS = {
    "songs" => Song,
    "channels" => Channel,
    "events" => Event,
    "orchestras" => Orchestra,
    "videos" => Video,
    "dancers" => Dancer
  }

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
    results = get_results(MODELS[category]).includes(image_attachments(MODELS[category].to_s))
    results.any? ? map_results(category, results.sort_by(&:relevancy).reverse.take(DEFAULT_LIMIT)) : []
  end

  def all_results
    models_with_results = MODELS.values.flat_map { |model| get_results(model).includes(image_attachments(model)) }
    results = models_with_results.reject(&:empty?)
    results.any? ? map_results_all(results.flatten) : []
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

  def map_results(category, results)
    results.map { |result| [category, result] }
  end

  def map_results_all(results)
    results.map { |result| [model_category(result), result] }
  end

  def model_category(record)
    MODELS.invert[record.class]
  end

  def image_attachments(model)
    case model.to_s
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
