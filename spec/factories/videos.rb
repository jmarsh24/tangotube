FactoryBot.define do
  factory :video do
    title { "Carlitos Espinoza and Noelia Hurtado Embrace Berlin 2019" }
    description { "24-26.10.2014 r., Amsterdam, Netherlands, Performance 25th Oct, \"Salon de los Sabados\" in Academia de Tango" }
    tags { %w[tango video] }
    thumbnail { Rack::Test::UploadedFile.new("spec/fixtures/files/thumbnail_1.jpg") }
    youtube_id { |i| OpenSSL::Digest.hexdigest("SHA1", i.to_s)[0..10] }
    duration { 232 }
    # association :playlist, factory: :playlist
    association :channel, factory: :channel
    # association :dancer, factory: :dancer
    # association :song, factory: :song
    # association :clip, factory: :clip
    # association :performance, factory: :performance
    # association :orchestra, factory: :orchestra
    # association :couple, factory: :couple

    upload_date { DateTime.now }

    trait :yt_music_scanned do
      scanned_youtube_music { true }
    end

    trait :yt_music_match_found do
      youtube_song { "Chandelier" }
      youtube_artist { "Sia" }
    end

    trait :acr_cloud_scanned do
      scanned_song { true }
    end

    trait :acr_cloud_match_found do
      acr_response_code { 0 }
    end

    trait :acr_cloud_match_not_found do
      acr_response_code { 1001 }
    end

    trait :acr_cloud_quota_exceeded do
      acr_response_code { 3003 }
    end

    trait :acr_cloud_fingerprint_cannot_be_generated do
      acr_response_code { 2004 }
    end

    trait :featured do
      featured { true }
    end

    trait :spotify_match do
      spotify_album_id { "6vV5UrXcfyQD1wu4Qo2I9k" }
      spotify_album_name { "1000 Forms of Fear" }
      spotify_artist_id { "5WUlDfRSoLAfcVSX1WnrxN" }
      spotify_artist_id_2 { "5WUlDfRSoLAfcVSX1WnrxN" }
      spotify_artist_name { "Sia" }
      spotify_artist_name_2 { "Sia" }
      spotify_track_id { "0WqIKmW4BTrj3eJFmnCKMv" }
      spotify_track_name { "Chandelier" }
      acr_cloud_artist_name { "Sia" }
      acr_cloud_artist_name_1 { "Sia" }
      acr_cloud_album_name { "1000 Forms of Fear" }
      acr_cloud_track_name { "Chandelier" }
      spotify_artist_id_1 { "5WUlDfRSoLAfcVSX1WnrxN" }
      spotify_artist_name_1 { "Sia" }
    end

    trait :with_dancers do
      association :leader, factory: :dancer
      association :follower, factory: :dancer
    end

    # factory :successful_acr_match, traits: [:spotify_match, :acr_cloud_match_found]
    # factory :successful_yt_music_match, traits: [:yt_music_match_found]
    # factory :successful_yt_music_and_acr_match, traits: [:yt_music_match_found, :acr_cloud_match_found]
    # factory :featured, traits: [:featured]
  end
end
