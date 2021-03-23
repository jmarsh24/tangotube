# == Schema Information
#
# Table name: followers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  buildd_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#  nickname   :string
#  first_name :string
#  last_name  :string
#
require "rails_helper"

RSpec.describe Follower, type: :model do
  let(:follower) { build(:follower) }

  it_behaves_like "a full nameable"
  it_behaves_like "a reviewable", :follower

  context "validation tests" do
    subject { FactoryBot.build(:follower) }

    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:leader) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:leader).through(:videos) }

    it "ensures name presence" do
      follower.name = nil
      expect(follower.save).to eq(false)
    end
  end
end
