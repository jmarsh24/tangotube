# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id       :bigint
#  youtube_id     :string
#  upload_date    :date
#  dancer_names   :text
#  channel_title  :text
#  song_title     :text
#  song_artist    :text
#  orchestra_name :text
#  event_city     :text
#  event_title    :text
#  event_country  :text
#  video_title    :text
#  score_1        :float
#
class VideoSearch < ApplicationRecord
  self.primary_key = :id
  belongs_to :video

  class << self
    def search(term)
      normalized_term = TextNormalizer.normalize(term)
      quoted_term = ActiveRecord::Base.connection.quote_string(normalized_term)

      video_searches = self
        .select("video_id, score")
        .where(":term % dancer_names OR :term % channel_title OR :term % song_title OR :term % song_artist OR :term % orchestra_name OR :term % event_city OR :term % event_title OR :term % event_country OR :term % video_title", term: quoted_term)
        .order("score DESC")

      video_searches.map(&:video_id)
    end

    def refresh
      Scenic.database.refresh_materialized_view("video_searches", concurrently: true, cascade: false)
    end
  end

  def readonly?
    true
  end
end
