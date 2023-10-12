# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.on_thread_error = ->(exception) { Rails.error.report(exception) }
  config.good_job.execution_mode = :async
  config.good_job.queues = "*"
  config.good_job.max_threads = 5
  config.good_job.poll_interval = 5 # seconds
  config.good_job.shutdown_timeout = 60 # seconds
  config.good_job.enable_cron = true
  config.good_job.dashboard_default_locale = :en
  config.good_job.cron = {
    enqueue_channel_video_fetcher_for_all_channels_with_music_recognizer: {
      cron: "0 5 * * *",
      class: "ImportNewVideosForAllChannelsJob",
      args: {
        use_scraper: false,
        use_music_recognizer: true
      },
      enabled: ENV["RAILS_ENV"] == "production"
    },
    enqueue_channel_video_fetcher_for_all_channels_without_music_recognizer: {
      cron: "0 5 * * *",
      class: "ImportNewVideosForAllChannelsJob",
      args: {
        use_scraper: false,
        use_music_recognizer: false
      },
      enabled: false
    },
    enqueue_update_music_recognized_videos_job: {
      cron: "0 12 * * *",
      class: "UpdateUnrecognizedMusicVideosJob",
      enabled: ENV["RAILS_ENV"] == "production"
    },
    enqueue_update_active_channels_job: {
      cron: "0 3 * * *",
      class: "UpdateActiveChannelsJob",
      enabled: ENV["RAILS_ENV"] == "production"
    },
    sitemap: {
      cron: "0 0 12 * *",
      class: "Shimmer::SitemapJob"
    },
    refresh_video_searches_view: {
      cron: "0 * * * *", # every hour
      class: "RefreshVideoSearchesViewJob",
      queue: "low_priority",
      enabled: ENV["RAILS_ENV"] == "production"
    },
    refresh_video_scores_scores: {
      cron: "*/10 * * * *", # every 10 minutes
      class: "RefreshVideoScoresJob",
      queue: "low_priority",
      enabled: ENV["RAILS_ENV"] == "production"
    }
  }
end
