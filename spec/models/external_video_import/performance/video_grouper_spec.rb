# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Performance::VideoGrouper do
  fixtures :all

  let(:channel) { channels(:jkukla_video) }
  let(:upload_date) { Date.parse("Sun, 26 Oct 2014") }
  let(:performance_video_2) { Video.create!(title: "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #2", youtube_id: "MQ96oN4AnKw", channel:, upload_date:) }
  let(:performance_video_1) { videos(:video_1_featured) }
  let(:performance_1) { performances(:performance_1) }
  let(:leader) { dancers(:carlitos) }
  let(:follower) { dancers(:noelia) }

  describe "#group_to_performance" do
    it "groups videos with existing performance" do
      DancerVideo.create!(dancer: leader, video: performance_video_2, role: :leader)
      DancerVideo.create!(dancer: follower, video: performance_video_2, role: :follower)
      performance = ExternalVideoImport::Performance::VideoGrouper.new(video: performance_video_2).group_to_performance
      expect(performance).to eq(performance_1)
      expect(performance_video_2.performance).to eq(performance_1)
      expect(performance_video_2.performance_video.position).to eq(2)
    end

    it "groups videos with non-existing performance" do
      performance_1.destroy!
      DancerVideo.create!(dancer: leader, video: performance_video_2, role: :leader)
      DancerVideo.create!(dancer: follower, video: performance_video_2, role: :follower)
      performance = ExternalVideoImport::Performance::VideoGrouper.new(video: performance_video_2).group_to_performance
      expect(performance_video_2.performance).to eq(performance)
      expect(performance_video_2.performance_video.position).to eq(2)
      expect(performance_video_1.performance_video.position).to eq(1)
      expect(performance_video_1.performance_video.performance).to eq(performance)
    end
  end
end
