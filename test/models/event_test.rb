# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string           not null
#  city         :string           not null
#  country      :string           not null
#  category     :string
#  start_date   :date
#  end_date     :date
#  active       :boolean          default(TRUE)
#  reviewed     :boolean          default(FALSE)
#  videos_count :integer          default(0), not null
#  slug         :string
#
require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
