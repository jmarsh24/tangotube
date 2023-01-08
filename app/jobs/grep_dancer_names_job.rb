# frozen_string_literal: true

class GrepDancerNamesJob < ApplicationJob
  queue_as :low_priority

  def perform
    Dancer.all.find_each(&:find_videos)
  end
end
