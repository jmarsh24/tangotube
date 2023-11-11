# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.on_thread_error = ->(exception) { Rails.error.report(exception) }
  config.good_job.execution_mode = :external
  config.good_job.queues = "*"
  config.good_job.max_threads = ENV.fetch("WORKER_MAX_THREADS", 3)
  config.good_job.poll_interval = 5 # seconds
  config.good_job.shutdown_timeout = 60 # seconds
  config.good_job.enable_cron = true
  config.good_job.dashboard_default_locale = :en
  config.good_job.cron = {
    channel_video_sync: {
      cron: "0 5 * * *",
      class: "SyncAllChannelVideosJob"
    },
    update_active_channels_job: {
      cron: "0 3 * * *",
      class: "UpdateActiveChannelsJob"
    },
    update_unrecognized_videos_job: {
      cron: "0 4 * * *",
      class: "UpdateUnrecognizedVideosJob"
    },
    sitemap: {
      cron: "0 0 12 * *",
      class: "Shimmer::SitemapJob"
    },
    refresh_video_searches_view: {
      cron: "0 * * * *", # every hour
      class: "RefreshVideoSearchesViewJob"
    },
    refresh_video_scores_scores: {
      cron: "*/30 * * * *", # every 10 minutes
      class: "RefreshVideoScoresJob"
    },
    refresh_query_stats: {
      cron: "*/5 * * * *", # every 5 minutes
      class: "CaptureQueryStatsJob"
    }
  }
end
