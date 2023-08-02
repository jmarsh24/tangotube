# frozen_string_literal: true

# == Schema Information
#
# Table name: recent_searches
#
#  id              :uuid             not null, primary key
#  user_id         :bigint           not null
#  searchable_type :string
#  searchable_id   :bigint
#  query           :string
#  category        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class RecentSearch < ApplicationRecord
  belongs_to :user
  belongs_to :searchable, polymorphic: true

  scope :most_recent, -> { order(created_at: :desc) }
  scope :unique_searches, -> {
    select("DISTINCT ON (recent_searches.searchable_id, recent_searches.searchable_type) recent_searches.*")
      .order("recent_searches.searchable_id, recent_searches.searchable_type, recent_searches.created_at DESC")
  }
end
