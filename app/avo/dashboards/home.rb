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
end
