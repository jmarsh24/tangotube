require "rails_helper"

RSpec.describe VideosSearch, type: :model do
  describe ".refresh" do
    it "materialized view able to be refreshed" do
      create(:video)
      expect { described_class.refresh }.to change(described_class, :count).from(0).to(1)
    end
  end
end
