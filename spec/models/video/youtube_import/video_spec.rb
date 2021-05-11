require "rails_helper"

RSpec.describe Video::YoutubeImport::Video, type: :model do
  describe ".import" do
    it "creates new video and channel if missing" do
      VCR.use_cassette("video/youtubeimport/video/api_response") do
        expect{described_class.import("s6iptZdCcG0")}.to change(Video, :count).from(0).to(1)

        video = Video.find_by(youtube_id: "s6iptZdCcG0")
        channel = Channel.find_by(channel_id: "UCtdgMR0bmogczrZNpPaO66Q")

        expect(video.youtube_id).to eq("s6iptZdCcG0")
        expect(video.title).to eq("Noelia Hurtado and Carlitos Espinoza – La mentirosa #NoeliayCarlitos")
        expect(video.description).to eq("Noelia Hurtado and Carlitos Espinoza dance “La mentirosa” by Osvaldo Pugliese, sung by Alberto Morán, at the milonga Ballhaus Rixdorf in Berlin, Germany.\n\nIf you love Tango videos, help us create more on\nhttp://www.patreon.com/030tango\n\nVisit 030tango at\nhttp://www.030tango.com\n\nRecorded on 2016/06/04\n#030tango #tango #NoeliayCarlitos")
        expect(video.upload_date.to_s).to eq("2018-03-04")
        expect(video.duration).to eq(219)
        expect(video.hd).to be(true)

        expect(video.view_count).to eq(46181)
        expect(video.favorite_count).to eq(0)
        expect(video.comment_count).to eq(8)
        expect(video.like_count).to eq(295)
        expect(video.dislike_count).to eq(9)

        expect(video.channel).to eq(channel)
      end
    end

    it "updates video if already exists" do
      VCR.use_cassette("video/youtubeimport/video/api_response") do
        video = create(:video, youtube_id: "s6iptZdCcG0",
                                title: "old title",
                                description: "old description",
                                upload_date: "old date",
                                duration: "old duration",
                                hd: false,
                                view_count: 0,
                                favorite_count: 0,
                                comment_count: 0,
                                like_count: 0,
                                dislike_count: 0)
        described_class.import("s6iptZdCcG0")
        video.reload

        expect(video.youtube_id).to eq("s6iptZdCcG0")
        expect(video.title).to eq("Noelia Hurtado and Carlitos Espinoza – La mentirosa #NoeliayCarlitos")
        expect(video.description).to eq("Noelia Hurtado and Carlitos Espinoza dance “La mentirosa” by Osvaldo Pugliese, sung by Alberto Morán, at the milonga Ballhaus Rixdorf in Berlin, Germany.\n\nIf you love Tango videos, help us create more on\nhttp://www.patreon.com/030tango\n\nVisit 030tango at\nhttp://www.030tango.com\n\nRecorded on 2016/06/04\n#030tango #tango #NoeliayCarlitos")
        expect(video.upload_date.to_s).to eq("2018-03-04")
        expect(video.duration).to eq(219)
        expect(video.hd).to be(true)

        expect(video.view_count).to eq(46181)
        expect(video.favorite_count).to eq(0)
        expect(video.comment_count).to eq(8)
        expect(video.like_count).to eq(295)
        expect(video.dislike_count).to eq(9)
      end
    end

    it "assigns video to channel if it already exists" do
      VCR.use_cassette("video/youtubeimport/video/api_response") do
        channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
        expect{described_class.import("s6iptZdCcG0")}.to change(Video, :count).from(0).to(1)
        video = Video.find_by(youtube_id: "s6iptZdCcG0")

        expect(video.youtube_id).to eq("s6iptZdCcG0")
        expect(video.title).to eq("Noelia Hurtado and Carlitos Espinoza – La mentirosa #NoeliayCarlitos")
        expect(video.description).to eq("Noelia Hurtado and Carlitos Espinoza dance “La mentirosa” by Osvaldo Pugliese, sung by Alberto Morán, at the milonga Ballhaus Rixdorf in Berlin, Germany.\n\nIf you love Tango videos, help us create more on\nhttp://www.patreon.com/030tango\n\nVisit 030tango at\nhttp://www.030tango.com\n\nRecorded on 2016/06/04\n#030tango #tango #NoeliayCarlitos")
        expect(video.upload_date.to_s).to eq("2018-03-04")
        expect(video.duration).to eq(219)
        expect(video.hd).to be(true)

        expect(video.view_count).to eq(46181)
        expect(video.favorite_count).to eq(0)
        expect(video.comment_count).to eq(8)
        expect(video.like_count).to eq(295)
        expect(video.dislike_count).to eq(9)

        expect(video.channel).to eq(channel)
      end
    end
  end
end
