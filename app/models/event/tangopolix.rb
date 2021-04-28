class Event::Tangopolix
  PAGINATION_MAX_NUMBER = 469

  class << self
    delegate :fetch, to: :new
  end

  def fetch
    (1..PAGINATION_MAX_NUMBER).each { |id| fetch_page(id) }
  end

  private

  def fetch_page(id)
    Rails.logger.info "Page Number: #{id}"

    page = Page.new(id)
    page.create_events_from_tangopolix
  end
end
