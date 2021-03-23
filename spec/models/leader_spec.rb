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
require "rails_helper"

RSpec.describe Leader, type: :model do
  subject { FactoryBot.build(:leader) }

  it_behaves_like "a full nameable"
  it_behaves_like "a reviewable", :leader

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "assocations" do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:follower) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:follower).through(:videos) }
  end
end
