# == Schema Information
#
# Table name: followers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#  nickname   :string
#  first_name :string
#  last_name  :string
#
require 'rails_helper'

RSpec.describe Follower, type: :model do
  it { is_expected.to have_many(:videos) }

  context 'validation tests' do
    it 'ensures name presence' do
      leader = Leader.new(first_name: 'first', last_name: 'last').save
      expect(leader).to eq(false)
    end
  end
  context 'scope tests' do
  end
end
