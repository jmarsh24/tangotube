FactoryBot.define do
  factory :video do
    title { 'Example Title'}
    description { 'Example Description' }
    youtube_id { 'Example Youtube ID' }
    view_count {}
    acr_response_code {}
  end
end
