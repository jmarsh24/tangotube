require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport::Video, type: :model do
  describe ".import" do
    it "creates new video if missing" do
      youtube_video = described_class.new("ABC")
      yt_response = instance_double(Yt::Video, id:             "valid_youtube_video_id",
                                               title:          "video_title",
                                               description:    "test",
                                               published_at:   "test",
                                               duration:       "test",
                                               tags:           "test",
                                               view_count:     "test",
                                               comment_count:  "test",
                                               favorite_count: "test",
                                               like_count:     "test",
                                               dislike_count:  "test")

      allow(Yt::Video).to receive(:new).and_return(yt_response)

      youtube_video.stub(:base_params) do
        { youtube_id:  "valid_youtube_video_id",
          title:       "video_title",
          description: "test",
          upload_date: "test",
          duration:    "test",
          tags:        "test",
          hd:          true }

        expect { described_class.import("ABC") }.to change(Video, :count).from(0).to(1)
      end
    end
  end
end
