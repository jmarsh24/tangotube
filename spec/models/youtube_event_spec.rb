# == Schema Information
#
# Table name: youtube_events
#
#  id                :bigint           not null, primary key
#  data              :jsonb
#  status            :integer          default("pending")
#  processing_errors :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe YoutubeEvent do
  pending "add some examples to (or delete) #{__FILE__}"
end
