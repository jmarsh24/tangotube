# frozen_string_literal: true

# == Schema Information
#
# Table name: couples
#
#  id               :bigint           not null, primary key
#  dancer_id        :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  partner_id       :bigint
#  videos_count     :integer          default(0), not null
#  slug             :string
#  unique_couple_id :string
#
require "rails_helper"

RSpec.describe Couple do
  pending "add some examples to (or delete) #{__FILE__}"
end
