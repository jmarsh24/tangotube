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
FactoryBot.define do
  factory :youtube_event do
    data { "MyText" }
    status { 1 }
    processing_errors { "MyString" }
  end
end
