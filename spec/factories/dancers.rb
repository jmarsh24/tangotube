# == Schema Information
#
# Table name: dancers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  first_name   :string
#  last_name    :string
#  middle_name  :string
#  nick_name    :string
#  user_id      :bigint
#  bio          :text
#  slug         :string
#  reviewed     :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  gender       :integer
#
FactoryBot.define do
  factory :dancer do
    first_name { "MyString" }
    last_name { "MyString" }
    middle_name { "MyString" }
    nick_name { "MyString" }
    user { nil }
    bio { "MyText" }
    slug { "MyString" }
    reviewed { false }
    couple { nil }
  end
end
