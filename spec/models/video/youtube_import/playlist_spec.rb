# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport::Playlist do
  describe "#import" do
    it "creates new playlist if missing" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response") do
        expect { described_class.import("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { Playlist.count }.from(0).to(1)
        playlist = Playlist.find_by(slug: "PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect(playlist.slug).to eq("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect(playlist.title).to eq("tangotube test")
        expect(playlist.description).to eq("")
        expect(playlist.channel_title).to eq("Justin Marsh")
        expect(playlist.channel_id).to be_nil
        expect(playlist.video_count).to eq("2")
        expect(playlist.imported).to be(false)
        expect(playlist.reviewed).to be(false)
      end
    end

    it "updates playlist information if playlist already exists" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response") do
        playlist = create(:playlist, slug: "PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect(Playlist.count).to eq(1)
        expect { described_class.import("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { Playlist.count }
        playlist.reload

        expect(playlist.slug).to eq("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect(playlist.title).to eq("tangotube test")
        expect(playlist.description).to eq("")
        expect(playlist.channel_title).to eq("Justin Marsh")
        expect(playlist.channel_id).to be_nil
        expect(playlist.video_count).to eq("2")
        expect(playlist.imported).to be(false)
        expect(playlist.reviewed).to be(false)
      end
    end
  end

  describe "#import_videos" do
    it "import all videos" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_videos") do
        expect { described_class.import("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { Playlist.count }.from(0).to(1)

        expect { described_class.import_videos("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportVideoJob.jobs.size }.by(2)
      end
    end

    it "imports only new videos" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_videos") do
        create(:playlist, slug: "PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect { described_class.import("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { Playlist.count }
        create(:video, youtube_id: "s6iptZdCcG0")

        expect { described_class.import_videos("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportVideoJob.jobs.size }.by(1)
      end
    end

    it "doesn't import new videos" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_videos") do
        create(:playlist, slug: "PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        create(:video, youtube_id: "s6iptZdCcG0")
        create(:video, youtube_id: "QmJacJnz0o0")

        expect { described_class.import("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { Playlist.count }

        expect { described_class.import_videos("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { ImportVideoJob.jobs.size }
      end
    end
  end

  describe "#import_channels" do
    it "imports all channels" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_channels") do
        expect { described_class.import_channels("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportChannelJob.jobs.size }.by(2)
      end
    end

    it "imports only new channels" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_channels") do
        create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
        expect { described_class.import_channels("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportChannelJob.jobs.size }.by(1)
      end
    end

    it "imports all channels" do
      VCR.use_cassette("video/youtubeimport/playlist/api_response_channels") do
        create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
        create(:channel, channel_id: "UCceZHjU9BkQM_Nz14N3wQKw")
        expect { described_class.import_channels("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { ImportChannelJob.jobs.size }
      end
    end
  end
end
