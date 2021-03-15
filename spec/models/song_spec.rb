require "rails_helper"

RSpec.describe Song, type: :model do
  let(:song) { build(:leader) }
  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:artist) }

  it { is_expected.to have_many(:videos) }
  it { is_expected.to have_many(:leader).through(:videos) }
  it { is_expected.to have_many(:follower).through(:videos) }

  describe ".sort_by_popularity" do
    it "includes users with admin flag" do
      admin = Song.create!(admin: true)
      expect(User.admins).to include(admin)
    end
end
