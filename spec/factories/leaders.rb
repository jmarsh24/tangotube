# == Schema Information
#
# Table name: leaders
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  reviewed     :boolean
#  nickname     :string
#  first_name   :string
#  last_name    :string
#  videos_count :integer          default(0), not null
#
FactoryBot.define do
  factory :leader do
    sequence(:name) { |n| "John Doe #{n}" }
  end
end
