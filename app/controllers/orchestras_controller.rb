# frozen_string_literal: true

class OrchestrasController < ApplicationController
  # @route GET /orchestras/top (top_orchestras)
  def top_orchestras
    @orchestras = Orchestra.most_popular.with_attached_profile_image.limit(24).load_async
  end
end
