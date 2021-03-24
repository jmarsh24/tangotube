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
end
