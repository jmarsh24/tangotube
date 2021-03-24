# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#  city       :string
#  country    :string
#  category   :string
#  start_date :date
#  end_date   :date
#  active     :boolean          default(TRUE)
#  reviewed   :boolean          default(FALSE)
#
class Event < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :city, presence: true
  validates :country, presence: true

  has_many :videos, dependent: :nullify

  def search_title
    @search_title ||= title.split("-")[0].strip
  end

  def videos_with_event_title_match
    Video.joins(:channel)
         .where(event_id: nil)
         .where("unaccent(videos.title) ILIKE unaccent(:query) OR
                  unaccent(videos.description) ILIKE unaccent(:query) OR
                  unaccent(videos.tags) ILIKE unaccent(:query) OR
                  unaccent(channels.title) ILIKE unaccent(:query)",
                query: "%#{search_title}%")
  end

  def match_videos
    return if search_title.split.size < 2 || videos_with_event_title_match.empty?

    videos_with_event_title_match.find_each do |video|
      video.update(event_id: id)
    end
  end

  class << self
    def title_search(query)
      words = query.to_s.strip.split
      words.reduce(all) do |combined_scope, word|
        combined_scope.where("unaccent(title) ILIKE unaccent(:query)", query: "%#{word}%")
      end
    end

    def match_all_events
      Event.all.order(:id).each do |event|
        MatchEventWorker.perform_async(event.id)
      end
    end
  end
end
