require "rails_helper"

 RSpec.describe Video::MusicRecognition::Youtube, type: :model do
    describe ".import" do
     it "updates existing record" do
       video = create(:video, youtube_id: "ABC", youtube_song: nil, youtube_artist: nil)
       youtube_dl_response = File.read("test/fixtures/youtube-dl_response_success.json")
      
       allow_any_instance_of(described_class).to(receive(:fetch_youtube_video_info_by_id).and_return( youtube_dl_response ))
       described_class.fetch("ABC")
       video.reload
       expect(video.youtube_song).to eq("La mentirosa")
       expect(video.youtube_artist).to eq("Osvaldo Pugliese con Alberto Morán")
     end

     it "returns video_params if internal video not found" do
       youtube_dl_response = File.read("test/fixtures/youtube-dl_response_success.json")

       allow_any_instance_of(described_class).to(receive(:fetch_youtube_video_info_by_id).and_return( youtube_dl_response ))

       response = "Artist: Osvaldo Pugliese con Alberto Morán, Track: La mentirosa, but could not save because no internal video record found."

       expect(described_class.fetch("ABC")).to eq(response)
     end

     it "returns video with nil attributes if no track or artist attribute present" do
       video = create(:video, youtube_id: "ABC", youtube_song: nil, youtube_artist: nil)
       youtube_dl_response = File.read("test/fixtures/youtube-dl_response_fail.json")

       allow_any_instance_of(described_class).to(receive(:fetch_youtube_video_info_by_id).and_return( youtube_dl_response ))
       described_class.fetch("ABC")
       video.reload

       expect(video.youtube_song).to be_nil
       expect(video.youtube_artist).to be_nil
     end
   end
 end
