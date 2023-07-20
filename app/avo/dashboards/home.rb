# frozen_string_literal: true

class Home < Avo::Dashboards::BaseDashboard
  self.id = "home"
  self.name = "Home"
  self.grid_cols = 3
  self.visible = -> do
    true
  end

  self.authorize = -> do
    current_user.admin?
  end

  card DailyImportedVideos
  card DailyImportedChannels
  card DailyUserSignups
  card UsersCountMetric,
    label: "Users Metric",
    description: "Count of the users."
  card VideosCountMetric,
    label: "Total Videos Count",
    description: "Count of the all videos.",
    options: {
      videos_count: true
    }
  card VideosCountMetric,
    label: "Count of featured Videos",
    description: "Count of the featured videos.",
    options: {
      featured_videos: true
    }
  card VideosCountMetric,
    label: "Count of Visible Videos",
    description: "Count of the visible videos.",
    options: {
      visible_videos: true
    }
  card VideosCountMetric,
    label: "Unrecognized Videos Metric",
    description: "Count of the unrecognized videos.",
    options: {
      unrecognized_videos: true
    }
  card VideosCountMetric,
    label: "Recognized Music Videos Metric",
    description: "Count of the recognized music videos.",
    options: {
      music_recognized: true
    }
end
