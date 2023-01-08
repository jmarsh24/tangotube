# frozen_string_literal: true

# == Schema Information
#
# Table name: orchestras
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  bio          :text
#  slug         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  songs_count  :integer          default(0), not null
#
FactoryBot.define do
  factory :orchestra do
    song { nil }
    video { nil }
    name { "MyString" }
    bio { "MyText" }
    slug { "MyString" }
  end
end
