require 'rails_helper'

RSpec.describe Channel, type: :model do
  it { is_expected.to have_many(:videos) }
end
