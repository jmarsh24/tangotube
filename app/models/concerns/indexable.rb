# frozen_string_literal: true

module Indexable
  extend ActiveSupport::Concern

  STOP_WORDS = {
    en: ["a", "an", "and", "are", "as", "at", "be", "but", "by", "for", "if", "in", "into", "is", "it", "no", "not", "of", "on", "or", "such", "that", "the", "their", "then", "there", "these", "they", "this", "to", "was", "will", "with"],
    es: ["un", "una", "unos", "unas", "y", "o", "pero", "por", "para", "como", "al", "de", "del", "los", "las"]
  }.freeze

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
                       .map { |term| remove_stop_words(term) }
                       .reduce(self) do |scope, term|
                         scope.select("*, similarity('#{ActiveRecord::Base.connection.quote_string(term)}', index) as score")
                           .where("index ILIKE ?", "%#{term}%")
                       end
                   end

    def index!(now: false)
      self.class.index!(id, now:)
    end

    private

    def self.remove_stop_words(term)
      languages = [:en, :es]
      stop_words = languages.map { |language| STOP_WORDS[language] }.compact.flatten
      return term unless stop_words

      term.split.reject { |word| stop_words.include?(word) }.join(" ")
    end
  end
end
