# == Schema Information
#
# Table name: search_suggestions
#
#  id         :bigint           not null, primary key
#  term       :string
#  popularity :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SearchSuggestion < ApplicationRecord
end
