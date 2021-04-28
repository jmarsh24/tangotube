# == Schema Information
#
# Table name: dancers
#
#  id            :bigint           not null, primary key
#  first_dancer  :string
#  second_dancer :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

corequire 'test_helper'

class DancerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
