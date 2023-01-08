# frozen_string_literal: true

module Normalizeable
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_name, on: [:create, :update]
    validates :normalized_name, presence: true, uniqueness: true

    def normalize_name
      self.normalized_name = full_name.downcase.parameterize(separator: " ")
    end
  end
end
