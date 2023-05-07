# frozen_string_literal: true

class VideoPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper

  include TitleLinkable
  include SongLinkable
  include MetaDataDisplayable
  include HdDataDisplayable
  include PerformanceNumberDisplayable

  private

  def format_date(performance_date)
    performance_date&.strftime("%B %Y")
  end
end
