# frozen_string_literal: true

class DailyImportedChannels < Avo::Dashboards::ChartkickCard
  self.id = "line_chart"
  self.label = "Daily Imported Channels"
  self.chart_type = :column_chart
  self.cols = 4
  self.flush = true
  self.scale = true
  self.legend = true

  def query
    data = Channel.where(created_at: 1.month.ago..Time.now).group_by_day(:created_at).count
    result(data)
  end
end
