require "rails_helper"

RSpec.describe Channel do
  it_behaves_like "an importable", :channel
  it_behaves_like "a reviewable", :channel

  describe "#update_imported" do
    it "doesn't update if the count is not changing" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499)
      expect { channel.update(title: "blah blah") }.not_to change(
        channel.reload,
        :imported
      )
    end

    it "updates the imported status if count is equal" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499, imported: false)
      channel.update(videos_count: 500)
      expect(channel.imported?).to be(true)
    end

    it "doesn't update if the videos count is greater than total_vides_count" do
      channel = create(:channel, total_videos_count: 500, videos_count: 499, imported: false)
      channel.update(videos_count: 501)
      expect(channel.imported?).to be(true)
    end

    it "doesn't update if the videos count is less than total_vides_count" do
      channel = create(:channel, total_videos_count: 500, videos_count: 400, imported: false)
      channel.update(videos_count: 401)
      expect(channel.imported?).to be(false)
    end
  end

  describe "scope" do
    describe "title_search" do
      it "returns channels that match title with exact match, without caps, without accents and with partial match" do
        matching_channel = create(:channel, title: "ChánneL Títle")
        no_match_channel = create(:channel)
        expect(described_class.title_search("ChánneL Títle")).to include(
          matching_channel
        )
        expect(described_class.title_search("ChánneL Títle")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("chánnel títle")).to include(
          matching_channel
        )
        expect(described_class.title_search("chánnel títle")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("channel title")).to include(
          matching_channel
        )
        expect(described_class.title_search("channel title")).not_to include(
          no_match_channel
        )
        expect(described_class.title_search("chann")).to include(
          matching_channel
        )
        expect(described_class.title_search("chann")).not_to include(
          no_match_channel
        )
      end
    end
  end
end
