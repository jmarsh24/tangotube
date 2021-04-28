require 'rails_helper'

RSpec.describe Leader, type: :model do
  it_behaves_like 'a full nameable'
  it_behaves_like 'a reviewable', :leader

  describe 'validations' do
    subject { FactoryBot.build(:leader) }

    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'assocations' do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:follower) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:follower).through(:videos) }
  end
end
