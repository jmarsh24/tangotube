class Event < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title, :city, :country]

  has_many :videos, dependent: :nullify
  has_one_attached :profile_image
  has_one_attached :cover_image

  validates :title, presence: true, uniqueness: true
  validates :city, presence: true
  validates :country, presence: true

  after_validation :set_slug, only: [:create, :update]

  def search_title
    return if title.empty?

    @search_title ||= title
  end

  def videos_with_event_title_match
    Video
      .joins(:channel)
      .where(event_id: nil)
      .where(
        'unaccent(videos.title) ILIKE unaccent(:query) OR
                  unaccent(videos.description) ILIKE unaccent(:query) OR
                  unaccent(videos.tags) ILIKE unaccent(:query) OR
                  unaccent(channels.title) ILIKE unaccent(:query)',
        query: "%#{search_title}%"
      )
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
        .each { |event| MatchEventWorker.perform_async(event.id) }
    end

    def rebuild_pg_search_documents
      find_each(&:update_pg_search_document)
    end
  end

  private

  def set_slug
    title.to_s.parameterize
  end
end


