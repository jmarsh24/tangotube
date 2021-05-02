require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
  end

  describe "associations" do
    it { is_expected.to have_many(:videos) }
  end

  describe "title_search" do
    it "returns channels that match title with exact match, without caps, without accents and with partial match" do
      matching_channel = create(:event, title: "Embrace Berlín")
      no_match_channel = create(:event)
      expect(described_class.title_search("Embrace Berlin")).to include(
        matching_channel
      )
      expect(described_class.title_search("Embrace Berlin")).not_to include(
        no_match_channel
      )
      expect(described_class.title_search("Embr")).to include(matching_channel)
      expect(described_class.title_search("Embr")).not_to include(
        no_match_channel
      )
      expect(described_class.title_search("race")).to include(matching_channel)
      expect(described_class.title_search("race")).not_to include(
        no_match_channel
      )
      expect(described_class.title_search("berlin embrace")).to include(
        matching_channel
      )
      expect(described_class.title_search("berlin embrace")).not_to include(
        no_match_channel
      )
    end
  end

  describe "#search_title" do
    it "creates searchable title" do
      event =
        create(:event, title: "Tango Event Title - unless search information")
      expect(event.search_title).to eq("Tango Event Title")
    end
  end

  describe ".videos_with_event_title_match(search_title)" do
    it "return video with title match in video title" do
      matching_video =
        create(:video, title: "Tango Event Title and other information")
      not_matched_video = create(:video, title: "Should not have match")
      event =
        create(:event, title: "Tango Event Title - useless search information")
      expect(event.videos_with_event_title_match).to include(matching_video)
      expect(event.videos_with_event_title_match).not_to include(
        not_matched_video
      )
    end

    it "return video with title match in video description" do
      matching_video =
        create(:video, description: "Tango Event Title and other information")
      not_matched_video = create(:video, description: "Should not have match")
      event =
        create(:event, title: "Tango Event Title - useless search information")
      expect(event.videos_with_event_title_match).to include(matching_video)
      expect(event.videos_with_event_title_match).not_to include(
        not_matched_video
      )
    end

    it "return video with title match in video tags" do
      matching_video =
        create(:video, tags: "Tango Event Title and other information")
      not_matched_video = create(:video, tags: "Should not have match")
      event =
        create(:event, title: "Tango Event Title - useless search information")
      expect(event.videos_with_event_title_match).to include(matching_video)
      expect(event.videos_with_event_title_match).not_to include(
        not_matched_video
      )
    end

    it "return video with title match in video channel title" do
      matching_channel =
        create(:channel, title: "Tango Event Title and other information")
      not_matching_channel = create(:channel, title: "Should not have match")
      matching_video = create(:video, channel: matching_channel)
      not_matched_video = create(:video, channel: not_matching_channel)
      event =
        create(:event, title: "Tango Event Title - useless search information")
      expect(event.videos_with_event_title_match).to include(matching_video)
      expect(event.videos_with_event_title_match).not_to include(
        not_matched_video
      )
    end
  end

  describe "match_videos" do
    it "doesnt perform if title is less than 2 words" do
      event = create(:event, title: "shorttitle")
      expect(event.match_videos).to be_nil
    end

    it "doesnt perform if title videos with title match is empty" do
      event = create(:event, title: "shorttitle")
      create(:video, title: nil)
      expect(event.match_videos).to be_nil
    end

    it "updates video with event if event title matches video title" do
      event = create(:event, title: "event title match")
      video = create(:video, title: "event title match", event_id: nil)
      event.match_videos
      expect(video.reload.event).to eq(event)
    end

    it "updates video with event if event title matches video description" do
      event = create(:event, title: "event title match")
      video = create(:video, description: "event title match", event_id: nil)
      event.match_videos
      expect(video.reload.event).to eq(event)
    end

    it "updates video with event if event title matches video tags" do
      event = create(:event, title: "event title match")
      video = create(:video, tags: "event title match", event_id: nil)
      event.match_videos
      expect(video.reload.event).to eq(event)
    end

    it "updates video with event if event title matches video's channel title" do
      channel = create(:channel, title: "event title match")
      event = create(:event, title: "event title match")
      video = create(:video, channel: channel, event_id: nil)
      event.match_videos
      expect(video.reload.event).to eq(event)
    end
  end
end
