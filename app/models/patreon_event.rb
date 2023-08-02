# frozen_string_literal: true

# == Schema Information
#
# Table name: patreon_events
#
#  id         :uuid             not null, primary key
#  event_type :string
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PatreonEvent < ApplicationRecord
end
