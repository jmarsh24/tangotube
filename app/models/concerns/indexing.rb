module Indexing
  extend ActiveSupport::Concern

  class_methods do
    def indexing(&block)
      after_commit on: [:create, :update] do
        objects = Array.wrap(instance_eval(&block)).flatten.compact
        next unless objects.any?

        objects.group_by(&:class).each do |klass, records|
          klass.index!(records.pluck(:id))
        end
      end
    end
  end
end
