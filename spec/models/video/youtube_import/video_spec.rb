# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::YoutubeImport::Video do
  fixtures :all
  let(:video) { videos(:video_1_featured) }
  let(:channel) { channels(:jkukla_video) }

  describe ".import" do
    context "when channel exists" do
      it "creates a new video" do
        video.destroy

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import(video.youtube_id) }
            .to change { Video.count }.by(1)

          expect(video.youtube_id).to eq("AQ9Ri3kWa_4")
          expect(video.title).to eq("Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1")
          expect(video.description).to eq("24-26.10.2014 r., Amsterdam, Netherlands, Performance 25th Oct, \"Salon de los Sabados\" in Academia de Tango")
          expect(video.upload_date.to_s).to eq("2014-10-26")
          expect(video.duration).to eq(167)
          expect(video.hd).to be(true)
          expect(video.performance_date).to eq("2014-10-26 16:21:29.000000000 +0100")

          expect(video.view_count).to eq(1042)
          expect(video.favorite_count).to eq(0)
          expect(video.comment_count).to eq(0)
          expect(video.like_count).to eq(3)
          expect(video.channel).to eq(channels(:jkukla_video))
        end
      end
    end

    context "when channel does not exists" do
      it "creates new video and channel" do
        video.destroy
        channel.destroy

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import(video.youtube_id) }
            .to change { Video.count }.by(1).and \
              change { Channel.count }.by(1)
        end
      end
    end

    context "when video exists" do
      it "updates video" do
        video.update!(title: "Old title")

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import(video.youtube_id) }
            .to change { video.reload.title }.from("Old title").to("Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1")
        end
      end
    end
  end
end
