# frozen_string_literal: true

# == Schema Information
#
# Table name: performances
#
#  id           :bigint           not null, primary key
#  date         :date
#  videos_count :integer
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :performance do
    event { nil }
    date { "2022-07-22" }
    video { nil }
    videos_count { 1 }
    position { 1 }
    slug { "MyString" }
  end
end
