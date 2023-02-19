# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::YoutubeImport::Video do
  fixtures :all

  describe ".import" do
    context "when channel exists" do
      it "creates a new video" do
        video = videos :video_1_featured
        channel = channels :jkukla_video
        video.destroy!

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import("AQ9Ri3kWa_4") }.to change { Video.count }.by(1)

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
          expect(video.channel).to eq(channel)
        end
      end
    end

    context "when channel does not exists" do
      it "creates new video and channel" do
        video = videos :video_1_featured
        channel = channels :jkukla_video
        channel.destroy!
        video.destroy!

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import("AQ9Ri3kWa_4") }.to change { Video.count }.by(1).and change { Channel.count }.by(1)
        end
      end
    end

    context "when video exists" do
      it "updates video" do
        video = videos :video_1_featured
        video.update! title: "Old title"

        VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
          expect { Video::YoutubeImport::Video.import(video.youtube_id) }.to change { video.reload.title }.from("Old title").to("Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1")
        end
      end
    end

    context "when video does not exists" do
      it "raises error" do
        expect { Video::YoutubeImport::Video.import("123456789") }.to raise_error("Video with youtube_id: 123456789 does not exist in YouTube")
        expect(Video.find_by(youtube_id: "123456789")).to be_nil
      end
    end

    it "adds dancers if there is a title match" do
      video = videos :video_1_featured
      video.dancer_videos.map(&:destroy!)
      video.update! title: "Carlitos Espinoza & Noelia Hurtado in Amsterdam 2014 #1"

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.to change { video.reload.dancers.count }.by(2)
      end
    end

    it "tries to search for acrcloud match if doesn't exist yet" do
      video = videos :video_1_featured
      video.update!(acr_response_code: 3003)

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.to have_enqueued_job(AcrMusicMatchJob).exactly(1)
      end
    end

    it "does not try to search for acrcloud match has a response code of 1001" do
      video = videos :video_1_featured
      video.update!(acr_response_code: 1001)

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.not_to have_enqueued_job(AcrMusicMatchJob).exactly(1)
      end
    end

    it "does not try to search for acrcloud match has a response code of 0" do
      video = videos :video_1_featured
      video.update!(acr_response_code: 0)

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.not_to have_enqueued_job(AcrMusicMatchJob).exactly(1)
      end
    end

    it "tries to search for acrcloud match if doesn't exist yet" do
      video = videos :video_1_featured
      video.update!(acr_response_code: 3003)

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.to have_enqueued_job(AcrMusicMatchJob).exactly(1)
      end
    end

    it "youtube_song is missing then it will try to get it from youtube" do
      video = videos :video_1_featured
      video.update!(youtube_song: nil)

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.to have_enqueued_job(YoutubeMusicMatchJob).exactly(1)
      end
    end

    it "does not try to get song from youtube if already has a youtube_song" do
      video = videos :video_1_featured
      video.update!(youtube_song: "malandraca")

      VCR.use_cassette("video/youtubeimport/video", record: :new_episodes) do
        expect { Video::YoutubeImport::Video.update(video.youtube_id) }.not_to have_enqueued_job(YoutubeMusicMatchJob).exactly(1)
      end
    end
  end
end
