require "rails_helper"

RSpec.describe Video::MusicRecognition::AcrCloud::Client, type: :model do
  describe ".import" do
    it "successfully sends audio and returns response" do
      VCR.use_cassette("video/music_recognition/acr_cloud/client/api_response") do
        create(:video, youtube_id: "s6iptZdCcG0", youtube_song: nil, youtube_artist: nil)

        expected_acr_cloud_response = {"status"=>{"msg"=>"Success", "code"=>0, "version"=>"1.0"}, "metadata"=>{"music"=>[{"external_ids"=>{"isrc"=>"ARF040200415"}, "contributors"=>{"composers"=>["Anselmo A. Aieta/ Francisco Garcia Jimenez"]}, "label"=>"UMG - Universal Music Argentina S.A.", "duration_ms"=>195000, "score"=>100, "play_offset_ms"=>121020, "external_metadata"=>{}, "release_date"=>"2020-04-08", "genres"=>[{"name"=>"Tango"}, {"name"=>"World"}], "title"=>"La Mentirosa", "album"=>{"name"=>"Cantan Alberto Morán Y Roberto Chanel"}, "acrid"=>"0d07891de1a0b282efce9b20dfce2bba", "result_from"=>1, "artists"=>[{"name"=>"Osvaldo Pugliese", "langs"=>[{"code"=>"ja-Jpan", "name"=>"オスバルド・プグリエーセ"}, {"code"=>"ja-Hrkt", "name"=>"オスバルドプグリエーセ"}]}, {"name"=>"Alberto Moran", "langs"=>[{"code"=>"ja-Jpan", "name"=>"アルベルト・モラン"}, {"code"=>"ja-Hrkt", "name"=>"アルベルトモラン"}]}]}, {"external_ids"=>{"isrc"=>"FR2X42076267"}, "contributors"=>{"composers"=>["Francisco García Jiménez"], "lyricists"=>["Francisco García Jiménez"]}, "label"=>"BELIEVE - White Room Music", "duration_ms"=>200000, "score"=>40, "play_offset_ms"=>121800, "external_metadata"=>{"spotify"=>{"album"=>{"name"=>"Alberto Morán - A Popular Idol of Tango / Recordings 1954 - 1958"}, "artists"=>[{"name"=>"Alberto Morán"}], "track"=>{"name"=>"Lagrimas de sangre", "id"=>"6cQgZzZmzmgg6JmxwvotZy"}}}, "release_date"=>"2020-04-22", "genres"=>[{"name"=>"Latin - Tango"}], "title"=>"La Mentirosa", "album"=>{"name"=>"La Mentirosa"}, "acrid"=>"7acd85558a923642ea53371326568c0f", "result_from"=>1, "artists"=>[{"name"=>"Osvaldo Pugliese"}]}], "timestamp_utc"=>"2021-05-11 01:33:04"}, "cost_time"=>1.2090001106262, "result_type"=>0}

        acr_cloud_api_response = described_class.send_audio("test/fixtures/s6iptZdCcG0_109_129.mp3")

        expect(JSON.parse(acr_cloud_api_response)).to eq(expected_acr_cloud_response)
      end
    end
  end
end
