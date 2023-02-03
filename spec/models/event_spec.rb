# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string           not null
#  city         :string           not null
#  country      :string           not null
#  category     :string
#  start_date   :date
#  end_date     :date
#  active       :boolean          default(TRUE)
#  reviewed     :boolean          default(FALSE)
#  videos_count :integer          default(0), not null
#  slug         :string
#
require "rails_helper"

RSpec.describe Event do
  fixtures :all

  let(:event) { events(:event_1) }
  let(:event_2) { events(:event_2) }
  let(:channel) { channels(:channel_1) }
end
