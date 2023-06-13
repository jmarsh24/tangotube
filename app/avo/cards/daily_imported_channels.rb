class DailyImportedChannels < Avo::Dashboards::ChartkickCard
  self.id = "line_chart"
  self.label = "Daily Imported Channels"
  self.chart_type = :column_chart
  self.cols = 4
  self.flush = true
  self.scale = true
  self.legend = true

  def query
    data = Video.group_by_day(:imported_at).count
    result(data)
  end
end
