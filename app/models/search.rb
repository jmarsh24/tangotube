# frozen_string_literal: true

class Search
  attr_reader :term, :category

  DEFAULT_LIMIT = 5

  def initialize(term:, category: "all")
    @term = term
    @category = allowed_category(category)
  end

  def results
    @results ||=
      if category == "all"
        all_results
      else
        results_for_category
      end
  end

  private

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
