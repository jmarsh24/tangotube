require 'rails_helper'

RSpec.describe Leader, type: :model do
  it { is_expected.to have_many(:videos) }
end
