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
  let(:leader) { build(:leader) }

  it_behaves_like "a full nameable"

  context "validation tests" do
    subject { FactoryBot.build(:leader) }

    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:follower) }
    it { is_expected.to have_many(:song) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to have_many(:song).through(:videos) }
    it { is_expected.to have_many(:follower).through(:videos) }

    it "ensures name presence" do
      leader.name = nil
      expect(leader.save).to eq(false)
    end
  end

  context "scope tests" do
    it "includes leaders with reviewed flagged" do
      leader = create(:leader, reviewed: true)
      expect(described_class.reviewed).to include(leader)
    end

    it "includes leaders without reviewed flagged" do
      leader = create(:leader, reviewed: false)
      expect(described_class.not_reviewed).to include(leader)
    end


    it "finds a searched leader by beginning of name" do
      leader = create(:leader, name: "Test leader")
      @result = described_class.full_name_search("Test leader")
      expect(@result).to eq([leader])
    end

    it "finds a searched leader by with case insensitivity" do
      leader = create(:leader, name: "Test leader")
      @result = described_class.full_name_search("TEST LEADER")
      expect(@result).to eq([leader])
      @result = described_class.full_name_search("test leader")
      expect(@result).to eq([leader])
    end
  end

  context "method tests" do
  end
end
