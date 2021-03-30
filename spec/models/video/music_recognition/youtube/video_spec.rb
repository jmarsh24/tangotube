require "rails_helper"

RSpec.describe Video::MusicRecognition::Youtube::Video, type: :model do
  describe ".import" do
    it "creates new video if missing" do
      video = create(:video, youtube_id: "ABC", youtube_song: nil, youtube_artist: nil)

      yt_response = instance_double(YoutubeDL,
                                    [{ "track"  => "Youtube Song Name" },
                                     { "artist" => "Youtube Artist Name" }].to_json)

      allow(YoutubeDL).to receive(:download).and_return(yt_response)
      described_class.import("ABC")

      expect(video.youtube_song).to eq("Youtube Song Name")
      expect(video.youtube_artist).to eq("Youtube Artist Name")
    end
  end
end
