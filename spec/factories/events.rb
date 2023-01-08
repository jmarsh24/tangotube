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
FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Fancy event #{n}" }
    city { Faker::Address.city }
    country { Faker::Address.country }
  end
end
