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
require "rails_helper"

RSpec.describe Follower, type: :model do
  let(:follower) { build(:follower) }

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

  context "scope tests" do
    it "includes followers with reviewed flagged" do
      follower = create(:follower, reviewed: true)
      expect(described_class.reviewed).to include(follower)
    end

    it "includes followers without reviewed flagged" do
      follower = create(:follower, reviewed: false)
      expect(described_class.not_reviewed).to include(follower)
    end

    it "finds a searched follower by name" do
      follower = create(:follower, name: "Test follower")
      @result = described_class.full_name_search("Test follower")
      expect(@result).to eq([follower])
    end

    it "finds a searched follower by ending of name" do
      follower = create(:follower, name: "Test follower")
      @result = described_class.full_name_search("est follower")
      expect(@result).to eq([follower])
    end

    it "finds a searched follower by beginning of name" do
      follower = create(:follower, name: "Test follower")
      @result = described_class.full_name_search("Test followe")
      expect(@result).to eq([follower])
    end

    it "finds a searched follower by with case insensitivity" do
      follower = create(:follower, name: "Test follower")
      @result = described_class.full_name_search("TEST follower")
      expect(@result).to eq([follower])
      @result = described_class.full_name_search("test follower")
      expect(@result).to eq([follower])
    end
  end

  context "method tests" do
    it 'tests full_name to return "first_name last_name"' do
      follower = create(:follower)
      expect(follower.full_name).to eq("#{follower.first_name} #{follower.last_name}")
    end
  end
end
