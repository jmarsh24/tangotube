# frozen_string_literal: true

module Featureable
  extend ActiveSupport::Concern

  included do
    has_many :features, dependent: :destroy
  end

  def features?(featureable)
    features.where(featureable:).exists?
  end

  def feature_for(featureable)
    features.find_by(featureable:)
  end
end
