# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string           not null
#  city         :string           not null
#  country      :string           not null
#  category     :string
#  start_date   :date
#  end_date     :date
#  active       :boolean          default(TRUE)
#  reviewed     :boolean          default(FALSE)
#  videos_count :integer          default(0), not null
#  slug         :string
#
require "rails_helper"

RSpec.describe Event do
  fixtures :all

  let(:event) { events(:event_1) }
  let(:event_2) { events(:event_2) }
  let(:channel) { channels(:channel_1) }

  describe "title_search" do
    it "returns channels that match title with exact match, without caps, without accents and with partial match" do
      event_2 = create(:event)
      expect(described_class.title_search("Embrace Berlin")).to include(
        event
      )
      expect(described_class.title_search("Embrace Berlin")).not_to include(
        event_2
      )
      expect(described_class.title_search("Embr")).to include(event_1)
      expect(described_class.title_search("Embr")).not_to include(
        event_2
      )
      expect(described_class.title_search("race")).to include(event_1)
      expect(described_class.title_search("race")).not_to include(
        event_2
      )
      expect(described_class.title_search("berlin embrace")).to include(
        event
      )
      expect(described_class.title_search("berlin embrace")).not_to include(
        event_2
      )
    end
  end

  describe "#search_title" do
    it "creates searchable title" do
      expect(event_1.search_title).to eq("Tango Event Title")
    end
  end

  describe ".videos_with_event_title_match(search_title)" do
    it "return video with title match in video title" do
      expect(event_1.videos_with_event_title_match).to include(event_1)
      expect(event_1.videos_with_event_title_match).not_to include(
        event_2
      )
    end

    it "return video with title match in video description" do
      event_1
      event =
        create(:event, title: "Tango Event Title - useless search information")
      expect(event_1.videos_with_event_title_match).to include(event_1)
      expect(event_1.videos_with_event_title_match).not_to include(
        event_2
      )
    end

    it "return video with title match in video tags" do
      expect(event_1.videos_with_event_title_match).to include(event_1)
      expect(event_1.videos_with_event_title_match).not_to include(
        event_2
      )
    end

    it "return video with title match in video channel title" do
      expect(event_1.videos_with_event_title_match).to include(event_1)
      expect(event_1.videos_with_event_title_match).not_to include(
        event_2
      )
    end
  end

  describe "match_videos" do
    it "doesnt perform if title is less than 2 words" do
      expect(event_1.match_videos).to be_nil
    end

    it "doesnt perform if title videos with title match is empty" do
      expect(event_1.match_videos).to be_nil
    end

    it "updates video with event if event title matches video title" do
      event_1.match_videos
      expect(video.reload.event).to eq(event_1)
    end

    it "updates video with event if event title matches video description" do
      event_1.match_videos
      expect(video.reload.event).to eq(event_1)
    end

    it "updates video with event if event title matches video tags" do
      event_1.match_videos
      expect(video.reload.event).to eq(event_1)
    end

    it "updates video with event if event title matches video's channel title" do
      event_1.match_videos
      expect(video.reload.event).to eq(event_1)
    end
  end
end
