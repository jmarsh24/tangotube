# frozen_string_literal: true

module Indexable
  extend ActiveSupport::Concern

  included do
    class << self
      def index!(ids, now: false)
        ids = Array.wrap(ids)
        return if ids.empty?

        if now
          UpdateIndexJob.perform_now(name, ids)
        else
          UpdateIndexJob.set(wait: 15.seconds).perform_later(name, ids)
        end
      end

      def indexing(&block)
        after_save do
          objects = Array.wrap(instance_eval(&block))
          next unless objects.any?

          objects.each do |object|
            object.class.index!(object.id)
          end
        end
      end
    end

    scope :search, ->(terms) do
      Array.wrap(terms)
        .map { |e| e.tr("*", "").downcase }
        .reduce(self) do |scope, term|
          scope.where("word_similarity(?, index) > 0.3", "%#{term}%")
        end
    end
    def index!(now: false)
      self.class.index! id, now:
    end
  end
end
