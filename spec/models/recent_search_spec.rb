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
require "rails_helper"

RSpec.describe RecentSearch, type: :model do
  fixtures :all

  describe ".unique_by_searchable" do
    it "returns the most recent search for each searchable item" do
      user = users(:regular)

      searchable_item_1 = videos(:video_1_featured)
      searchable_item_2 = dancers(:carlitos)
      searchable_item_3 = channels(:"030tango")

      most_recent_search_3 = RecentSearch.create!(user:, searchable: searchable_item_3, created_at: 3.days.ago)
      most_recent_search_1 = RecentSearch.create!(user:, searchable: searchable_item_1, created_at: 1.day.ago)
      most_recent_search_2 = RecentSearch.create!(user:, searchable: searchable_item_2, created_at: 2.days.ago)

      expect(RecentSearch.unique_by_searchable).to contain_exactly(most_recent_search_1, most_recent_search_2, most_recent_search_3)
    end
  end
end
