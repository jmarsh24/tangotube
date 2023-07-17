# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id                    :bigint           primary key
#  youtube_id                  :string
#  upload_date                 :date
#  dancer_names                :text
#  channel_title               :text
#  song_title                  :text
#  song_artist                 :text
#  orchestra_name              :text
#  event_city                  :text
#  event_title                 :text
#  event_country               :text
#  video_title                 :text
#  days_since_upload           :decimal(, )
#  days_since_last_interaction :decimal(, )
#  freshness_score             :decimal(, )
#  interaction_freshness_score :decimal(, )
#  score                       :decimal(, )
#
class VideoSearch < ApplicationRecord
  self.primary_key = :video_id
  belongs_to :video

  class << self
    def search(term)
      normalized_term = TextNormalizer.normalize(term)
      quoted_term = ActiveRecord::Base.connection.quote_string(normalized_term)

      video_searches = self
        .select("video_id, score")
        .where("? % dancer_names OR ? % channel_title OR ? % song_title OR ? % song_artist OR ? % orchestra_name OR ? % event_city OR ? % event_title OR ? % event_country OR ? % video_title", quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term, quoted_term)
        .order("score DESC")

      video_searches.map(&:video_id)
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end
  end

  def refresh_video_search
    VideoSearch.refresh
  end

  def readonly?
    true
  end
end
