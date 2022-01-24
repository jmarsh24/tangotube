module Normalizeable
  extend ActiveSupport::Concern

  included do

    before_validation :normalize_name, on: [:create, :update]
    validates :normalized_name, presence: true, uniqueness: true

    def normalize_name
      self.normalized_name = name.downcase.parameterize(separator: " ")
    end
  end
end
