FactoryBot.define do
  factory :video_youtube_import_channel, class: "Video::YoutubeImport::Channel" do
    channel_id { "valid_youtube_channel_id" }
    title { "channel_title" }
    thumbnail_url { "channel_url" }
    total_videos_count { 500 }
    videos { %w[youtube_video_id youtube_video_id1 youtube_video_id2] }
  end
end
