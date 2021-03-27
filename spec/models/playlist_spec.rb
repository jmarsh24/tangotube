require "rails_helper"

RSpec.describe Playlist, type: :model do
  it_behaves_like "an importable", :playlist

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
