# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string
#  properties :jsonb
#  time       :datetime
#
class Ahoy::Event < AhoyRecord
  include Ahoy::QueryMethods

  MIN_NUMBER_OF_VIEWS = ENV["MINIMUM_NUMBER_OF_VIEWS"] || 3

  belongs_to :visit
  belongs_to :user, optional: true

  class << self
    def most_viewed_videos_by_month
      where("time > ?", 30.days.ago)
        .where(name: "Video View")
        .select("properties")
        .group("properties")
        .having("count(properties) >= ?", MIN_NUMBER_OF_VIEWS)
        .map(&:properties)
        .pluck("video_id")
        .compact
    end

    def viewed_by_user(user)
      where(name: "Video View")
        .where(user_id: user.id)
        .select("properties")
        .group("properties")
        .map(&:properties)
        .pluck("video_id")
        .compact
    end
  end
end
