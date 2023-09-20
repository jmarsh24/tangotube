# frozen_string_literal: true

module Featureable
  extend ActiveSupport::Concern

  def features?(featureable)
    features.where(featureable:).exists?
  end

  def feature_for(featureable)
    features.find_by(featureable:)
  end

  def featured?
    features.exists?
  end
end
