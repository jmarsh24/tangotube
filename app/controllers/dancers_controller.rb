# frozen_string_literal: true

class DancersController < ApplicationController
  # @route GET /dancers/top (top_dancers)
  def top_dancers
    @dancers = Dancer.most_popular.with_attached_profile_image.limit(128).shuffle.take(24)
  end
end
