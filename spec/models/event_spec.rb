# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#  city       :string
#  country    :string
#  category   :string
#  start_date :date
#  end_date   :date
#  active     :boolean          default(TRUE)
#  reviewed   :boolean          default(FALSE)
#
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

  describe ".title_search" do
    it "find event by title" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("Embrace Berlin")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title with partial prefix" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("Embr")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title with partial suffix" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("race")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title with partial middle match" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("brac")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title without accent" do
      match_event = create(:event, title: "Embrace Berlín")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("embrace berlin")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title with case insensitivity" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("embrace berlin")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end

    it "find event by title any word order" do
      match_event = create(:event, title: "Embrace Berlin")
      no_match_event = create(:event, title: "Not matching event")
      result = described_class.title_search("berlin embrace")
      expect(result).to include(match_event)
      expect(result).not_to include(no_match_event)
    end
  end

  describe ".search_title" do
    it "creates searchable title" do
      event = create(:event, title: "Tango Event Title - unless search information")
      expect(event.search_title).to eq("Tango Event Title")
    end
  end

  describe ".videos_with_event_title_match(search_title)" do
    it "return video with title match in video title" do
      matching_video = create(:video, title: "Tango Event Title and other information")
      not_matched_video = create(:video, title: "title which should have match")
      event = create(:event, title: "Tango Event Title - unless search information")
      expect(event.videos_with_event_title_match(event.search_title)).to include(matching_video)
      expect(event.videos_with_event_title_match(event.search_title)).not_to include(not_matched_video)
    end

    it "return video with title match in video description" do
      matching_video = create(:video, description: "Tango Event Title and other information")
      not_matched_video = create(:video, description: "title which should have match")
      event = create(:event, title: "Tango Event Title - unless search information")
      expect(event.videos_with_event_title_match(event.search_title)).to include(matching_video)
      expect(event.videos_with_event_title_match(event.search_title)).not_to include(not_matched_video)
    end

    it "return video with title match in video tags" do
      matching_video = create(:video, tags: "Tango Event Title and other information")
      not_matched_video = create(:video, tags: "title which should have match")
      event = create(:event, title: "Tango Event Title - unless search information")
      expect(event.videos_with_event_title_match(event.search_title)).to include(matching_video)
      expect(event.videos_with_event_title_match(event.search_title)).not_to include(not_matched_video)
    end

    it "return video with title match in video channel title" do
      matching_channel = create(:channel, title: "Tango Event Title and other information")
      not_matching_channel = create(:channel, title: "title which should have match")
      matching_video = create(:video, channel: matching_channel)
      not_matched_video = create(:video, channel: not_matching_channel)
      event = create(:event, title: "Tango Event Title - unless search information")
      expect(event.videos_with_event_title_match(event.search_title)).to include(matching_video)
      expect(event.videos_with_event_title_match(event.search_title)).not_to include(not_matched_video)
    end
  end
end
