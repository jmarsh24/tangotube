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
  scope :unique_by_searchable, -> {
                                 subquery = self.select("DISTINCT ON (searchable_id, searchable_type) recent_searches.*")
                                   .order("searchable_id, searchable_type, created_at DESC")
                                   .to_sql

                                 from("(#{subquery}) AS recent_searches").order("created_at DESC")
                               }
end
