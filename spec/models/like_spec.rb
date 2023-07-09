# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id            :uuid             not null, primary key
#  user_id       :bigint           not null
#  likeable_type :string           not null
#  likeable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Like, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
