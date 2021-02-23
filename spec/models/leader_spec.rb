# == Schema Information
#
# Table name: leaders
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

RSpec.describe Leader, type: :model do
  it { is_expected.to have_many(:videos) }

  let(:leader) { build(:leader) }

  context 'validation tests' do
    it 'ensures name presence' do
      leader.name = nil
      expect(leader.save).to eq(false)
    end
  end
  context 'scope tests' do
  end
end
