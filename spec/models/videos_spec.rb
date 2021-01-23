require 'rails_helper'

RSpec.describe Videos, type: :model do
  it { is_expected.to belong_to(:channel) }
end
