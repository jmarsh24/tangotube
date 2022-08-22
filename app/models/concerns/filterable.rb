module Filterable
  extend ActiveSupport::Concern

  module ClassMethods

    def filter_by(filtering_params, user)
      results = where(nil)
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value, user)
      end
      results
    end
  end
end
