# frozen_string_literal: true

class Home < Avo::Dashboards::BaseDashboard
  self.id = "Home"
  self.name = "Home"
  self.grid_cols = 3
  # self.visible = -> do
  #   true
  # end

  self.authorize = -> do
    current_user.admin?
  end

  card DailyImportedVideos
  card DailyImportedChannels
  card UsersCountMetric,
    label: "Users metric",
    description: "Count of the users."
  card VideosCountMetric,
    label: "Active videos metric",
    description: "Count of the featured videos.",
    options: {
      featured_videos: true
    }
  card VideosCountMetric,
    label: "Visible videos metric",
    description: "Count of the visible videos.",
    options: {
      visible_videos: true
    }
end
