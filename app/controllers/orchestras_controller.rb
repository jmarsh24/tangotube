# frozen_string_literal: true

class OrchestrasController < ApplicationController
  def top_orchestras
    @orchestras = Orchestra.most_popular.with_attached_profile_image.limit(24)
  end
end
