require "rails_helper"

RSpec.describe Song, type: :model do
  it { is_expected.to have_many(:videos) }
  it { is_expected.to have_many(:leader).through(:videos) }
  it { is_expected.to have_many(:follower).through(:videos) }
end
