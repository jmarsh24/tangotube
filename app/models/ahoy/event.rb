class Ahoy::Event < AhoyRecord
  include Ahoy::QueryMethods

  belongs_to :visit
  belongs_to :user, optional: true
  
  class << self
    def most_viewed_videos_by_month
       where("time > ?", 30.days.ago)
      .where(name: "Video View")
      .select("properties AS event, count(properties) AS occurrences")
      .group("properties")
      .order("occurrences DESC")
      .map(&:event)
      .pluck("youtube_id")
    end
  end
end
