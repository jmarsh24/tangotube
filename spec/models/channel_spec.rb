# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#
require "rails_helper"

RSpec.describe Channel, type: :model do
  it_behaves_like "an importable", :channel
  it_behaves_like "a reviewable", :channel

  describe "validations" do
    it { is_expected.to have_many(:videos) }
    it { is_expected.to validate_uniqueness_of(:channel_id) }
  end

  describe ".update_videos_count" do
    it "changes imported to false if total_videos_count is greater than internal videos_count" do
      channel = create(:channel, imported: true, total_videos_count: 500, videos_count: 499)
      channel.save
      expect(channel.reload.imported).to eq(false)
    end

    it "changes imported to true if total_videos_count is smaller than internal videos_count" do
      channel = create(:channel, imported: false, total_videos_count: 500, videos_count: 501)
      channel.save
      expect(channel.reload.imported).to eq(true)
    end

    it "changes imported to false if total_videos_count is greater than internal videos_count" do
      channel = create(:channel, imported: false, total_videos_count: 500, videos_count: 500)
      channel.save
      expect(channel.reload.imported).to eq(true)
    end
  end
end
