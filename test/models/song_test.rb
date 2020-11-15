# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  genre      :string
#  title      :string
#  artist     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class SongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
