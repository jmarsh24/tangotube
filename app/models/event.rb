# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string           not null
#  city         :string           not null
#  country      :string           not null
#  category     :string
#  start_date   :date
#  end_date     :date
#  active       :boolean          default(TRUE)
#  reviewed     :boolean          default(FALSE)
#  videos_count :integer          default(0), not null
#  slug         :string
#
class Event < ApplicationRecord
  has_many :videos, dependent: :nullify
  has_one_attached :profile_image
  has_one_attached :cover_image

  validates :title, presence: true, uniqueness: true
  validates :city, presence: true
  validates :country, presence: true

  after_validation :set_slug, only: [:create, :update]

  scope :most_popular, -> { order(videos_count: :desc) }
  scope :active, -> { where(active: true) }
  scope :search, ->(search_term) {
    terms = TextNormalizer.normalize(search_term).split(" ")

    trigram_queries = terms.map do |term|
      sanitized_term = ActiveRecord::Base.connection.quote_string(term)
      "(title % '#{sanitized_term}' OR city % '#{sanitized_term}' OR country % '#{sanitized_term}')"
    end

    similarity_scores = terms.map do |term|
      sanitized_term = ActiveRecord::Base.connection.quote_string(term)
      "((title <-> '#{sanitized_term}') + (city <-> '#{sanitized_term}') + (country <-> '#{sanitized_term}'))"
    end.join(" + ")

    where(trigram_queries.join(" OR "))
      .order(Arel.sql("#{similarity_scores} ASC, videos_count DESC"))
  }

  def search_title
    return if title.empty?

    @search_title ||= title
  end

  def match_videos
    return if event_title_length_match_validation

    videos_with_event_title_match.find_each do |video|
      video.update(event_id: id)
    end
  end

  def event_title_length_match_validation
    search_title.split.size < 2 || videos_with_event_title_match.empty?
  end

  def to_param
    "#{id}-#{slug}"
  end

  class << self
    def title_search(query)
      words = query.to_s.strip.split
      words.reduce(all) do |combined_scope, word|
        combined_scope.where(
          "unaccent(title) ILIKE unaccent(:query)",
          query: "%#{word}%"
        )
      end
    end

    def match_all_events(_event_id)
      Event
        .all
        .order(:id)
        .each { |event| MatchEventJob.perform_later(event.id) }
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active", "category", "city", "country", "created_at", "end_date", "id", "reviewed", "slug", "start_date", "title", "updated_at", "videos_count"]
  end

  private

  def set_slug
    title.to_s.parameterize
  end
end
