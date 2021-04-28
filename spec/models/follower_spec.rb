require 'rails_helper'

RSpec.describe Follower, type: :model do
  it_behaves_like 'a full nameable', :follower
  it_behaves_like 'a reviewable', :follower

  describe 'validations' do
    subject { FactoryBot.build(:follower) }

    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'assocations' do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:leader) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:leader).through(:videos) }
  end
end
