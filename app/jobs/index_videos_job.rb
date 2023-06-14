# frozen_string_literal: true

class IndexVideosJob < ApplicationJob
  queue_as :default

  def perform
    Video.find_in_batches.each { |video| Video.index!(video.map(&:id), now: false) }
  end
end
