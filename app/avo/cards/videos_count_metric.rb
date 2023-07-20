# frozen_string_literal: true

class VideosCountMetric < Avo::Dashboards::MetricCard
  self.id = "videos_metric"
  self.label = "Videos count"
  self.description = "Videos description"
  self.cols = 1
  self.initial_range = 30
  self.ranges = [7, 30, 60, 365, "TODAY", "MTD", "QTD", "YTD", "ALL"]
  self.refresh_every = 10.minutes

  def query
    from = Date.today.midnight - 1.week
    to = DateTime.current

    if range.present?
      if range.to_s == range.to_i.to_s
        from = DateTime.current - range.to_i.days
      else
        case range
        when "TODAY"
          from = DateTime.current.beginning_of_day
        when "MTD"
          from = DateTime.current.beginning_of_month
        when "QTD"
          from = DateTime.current.beginning_of_quarter
        when "YTD"
          from = DateTime.current.beginning_of_year
        when "ALL"
          from = Time.at(0)
        end
      end
    end

    scope = Video

    if options[:videos_count].present?
      scope
    end

    if options[:featured_videos].present?
      scope = scope.featured
    end

    if options[:visible_videos].present?
      scope = scope.not_hidden
    end

    if options[:music_recognized].present?
      scope = scope.music_recognized
    end

    if options[:music_unrecognized].present?
      scope = scope.music_unrecognized
    end

    result scope.where(created_at: from..to).count
  end
end
