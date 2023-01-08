# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id            :bigint           primary key
#  tsv_content_tsearch :tsvector
#
class VideoSearch < ApplicationRecord
  self.primary_key = :video_id

  include PgSearch::Model
  pg_search_scope(
    :search,
    against: :tsvector_content_tsearch,
    using: {
      tsearch: {
        dictionary: "english",
        tsvector_column: ["tsv_content_tsearch"]
      }
    }
  )

  def readonly?
    true
  end
end
