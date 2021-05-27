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
      .pluck("youtube_id")
    end
  end
end
