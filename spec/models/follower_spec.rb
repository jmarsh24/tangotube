# == Schema Information
#
# Table name: followers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  reviewed     :boolean
#  nickname     :string
#  first_name   :string
#  last_name    :string
#  videos_count :integer          default(0), not null
#
require "rails_helper"

RSpec.describe Follower, type: :model do
  subject { FactoryBot.build(:follower) }

  it_behaves_like "a full nameable"
  it_behaves_like "a reviewable", :follower

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "assocations" do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:leader) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:leader).through(:videos) }
  end
end
