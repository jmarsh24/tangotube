# == Schema Information
#
# Table name: songs
#
#  id               :bigint           not null, primary key
#  genre            :string
#  title            :string
#  artist           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  artist_2         :string
#  composer         :string
#  author           :string
#  date             :date
#  last_name_search :string
#  occur_count      :integer          default(0)
#  popularity       :integer          default(0)
#  active           :boolean          default(TRUE)
#  lyrics           :text
#
FactoryBot.define do
  factory :songs do
    genre { 'MyText' }
    artist { 'MyText' }
    artist_2 { 'MyText' }
    composer { 'MyText' }
    author { 'MyText' }
    date { 'MyText' }
    popularity { 'MyText' }
    active { true }
    lyrics { 'MyText' }
    last_name_search { 'MyText' }
  end
end
