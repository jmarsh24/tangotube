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

  scope :title_search, lambda { |query|
                         where("unaccent(title) ILIKE unaccent(:query)",
                               query: "%#{query}%")
                       }

  class << self
    def match_all_events
      Event.all.order(:id).each do |event|
        MatchEventWorker.perform_async(event.id)
      end
    end

    def match_event(event_id)
      event = Event.find(event_id)
      event_title = event.title.split("-")[0].strip

      if event_title.split.size > 2

        videos = Video.joins(:channel).where(event_id: nil).where("unaccent(videos.title) ILIKE unaccent(?) OR unaccent(videos.description) ILIKE unaccent(?) OR unaccent(videos.tags) ILIKE unaccent(?) OR unaccent(channels.title) ILIKE unaccent(?)", "%#{event_title}%",
                                                                  "%#{event_title}%", "%#{event_title}%", "%#{event_title}%")

        videos.update_all(event_id: event.id) if videos.present?
      end
    end
  end
end
