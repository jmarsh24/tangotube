# frozen_string_literal: true

# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/2.0/controllers.html
class Avo::DancersController < Avo::ResourcesController
  def create_success_action
    resource.model.update_video_matches
    super
  end

  def update_success_action
    resource.model.update_video_matches
    super
  end
end
