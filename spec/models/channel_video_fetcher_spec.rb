# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChannelVideoFetcher do
  fixtures :all

  describe "#fetch_new_videos" do
    it "fetches new videos for all channels", vcr: true do
      fetcher = ChannelVideoFetcher.new(channels(:"030tango").channel_id, use_scraper: false, use_music_recognizer: false)
      expect { fetcher.fetch_new_videos }.to have_enqueued_job(ImportVideoJob).exactly(2424).times
    end
  end
end
