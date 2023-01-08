# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport do
  describe ".from_channel" do
    it "creates channel if doesn't already exist" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_channel") do
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.to change { Channel.count }.from(0).to(1)
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.to change { ImportVideoJob.jobs.size }.by(5)
      end
    end

    it "doesn't create new channel if already exists and adds all videos" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_channel") do
        create(:channel, channel_id: "UC9lGGipk4wth0rDyy4419aw")
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.not_to change { Channel.count }
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.to change { ImportVideoJob.jobs.size }.by(5)
      end
    end

    it "adds only new videos" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_channel") do
        channel = create(:channel, channel_id: "UC9lGGipk4wth0rDyy4419aw")
        create(:video, youtube_id: "s8olH-kdwzw", channel:)
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.not_to change { Channel.count }
        expect { described_class.from_channel("UC9lGGipk4wth0rDyy4419aw") }.to change { ImportVideoJob.jobs.size }.by(4)
      end
    end
  end

  describe ".from_playlist" do
    it "creates playlist if doesn't already exist" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_playlist") do
        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { Playlist.count }.from(0).to(1)
        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportVideoJob.jobs.size }.by(2)
      end
    end

    it "doesn't create new playlist if already exists and adds all videos" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_playlist") do
        create(:playlist, slug: "PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb")
        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.not_to change { Playlist.count }
        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportVideoJob.jobs.size }.by(2)
      end
    end

    it "adds only new videos" do
      VCR.use_cassette("spec/cassettes/video/youtube_import/from_playlist") do
        create(:video, youtube_id: "s6iptZdCcG0")

        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { Playlist.count }.from(0).to(1)
        expect { described_class.from_playlist("PL_HOpEXNpyAZrjlgI_I_R47yQdhLRtBrb") }.to change { ImportVideoJob.jobs.size }.by(1)
      end
    end
  end

  describe ".from_video" do
    it "adds new videos" do
      expect(Video::YoutubeImport::Video).to receive(:import).with("s6iptZdCcG0")
      described_class.from_video("s6iptZdCcG0")
    end
  end
end
