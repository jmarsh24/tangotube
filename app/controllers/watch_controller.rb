class WatchController < ApplicationController
  def watch
    @active_video = Video.find(1)
  end
end
