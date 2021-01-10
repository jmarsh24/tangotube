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

require 'rails_helper'

RSpec.describe SearchSuggestion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
