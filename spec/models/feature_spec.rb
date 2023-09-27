# frozen_string_literal: true

# == Schema Information
#
# Table name: features
#
#  id               :uuid             not null, primary key
#  user_id          :bigint           not null
#  featureable_type :string           not null
#  featureable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe Feature, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
