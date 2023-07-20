# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id                  :bigint           not null, primary key
#  title               :string
#  channel_id          :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  thumbnail_url       :string
#  reviewed            :boolean          default(FALSE)
#  active              :boolean          default(TRUE)
#  description         :text
#  metadata            :jsonb
#  metadata_updated_at :datetime
#  videos_count        :integer          default(0)
#
require "rails_helper"

RSpec.describe Channel do
  fixtures :all

  describe "#fetch_and_save_metadata!", :vcr do
    it "fetches and saves the channel's metadata" do
      channel = channels(:"030tango")
      expect(channel.metadata).to be_nil

      travel_to Time.current do
        channel.fetch_and_save_metadata!
        channel.reload

        expect(channel.metadata.title).to eq("030tango")
        expect(channel.metadata.id).to eq("UCtdgMR0bmogczrZNpPaO66Q")
        expect(channel.metadata_updated_at).to eq(Time.current)
      end
    end

    it "destroys the channel if it doesn't exist on YouTube" do
      channel = channels(:"030tango")
      channel.update!(channel_id: "invalid")

      channel.fetch_and_save_metadata!

      expect(channel).to be_destroyed
    end
  end

  describe "#fetch_and_save_metadata_later!", :vcr do
    it "enqueues a job to fetch and save the channel's metadata" do
      channel = channels(:"030tango")

      travel_to Time.current do
        expect {
          channel.fetch_and_save_metadata_later!
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(1)

        perform_enqueued_jobs

        channel.reload

        expect(channel.metadata.title).to eq("030tango")
        expect(channel.metadata.id).to eq("UCtdgMR0bmogczrZNpPaO66Q")
        expect(channel.metadata_updated_at).to eq(Time.current)
      end
    end
  end
end
