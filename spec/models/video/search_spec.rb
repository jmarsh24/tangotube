require "rails_helper"

RSpec.describe Video::Search, type: :model do
  describe "#videos" do
    describe "sorting" do
      it "returns videos sorted by songs.last_name_search" do
        song_a = create(:song, last_name_search: "A")
        song_b = create(:song, last_name_search: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "songs.last_name_search",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "songs.last_name_search",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
        expect(search_asc.videos).not_to eq [video_a, video_b]
        expect(search_desc.videos).not_to eq [video_a, video_b]
      end

      it "returns videos sorted by songs.title" do
        song_a = create(:song, title: "A")
        song_b = create(:song, title: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "songs.title",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "songs.title",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
        expect(search_asc.videos).not_to eq [video_a, video_b]
        expect(search_desc.videos).not_to eq [video_a, video_b]
      end

      it "returns videos sorted by upload_date" do
        video_a = create(:video, upload_date: Time.new(2020, 1, 1))
        video_b = create(:video, upload_date: Time.new(2019, 1, 1))
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "videos.upload_date",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_a, video_b]
        expect(search_desc.videos).to eq [video_a, video_b]
        expect(search_asc.videos).not_to eq [video_b, video_a]
        expect(search_desc.videos).not_to eq [video_b, video_a]
      end

      it "returns videos sorted by view_count" do
        video_a = create(:video, view_count: 1)
        video_b = create(:video, view_count: 2)
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "videos.view_count",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "videos.view_count",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
        expect(search_asc.videos).not_to eq [video_a, video_b]
        expect(search_desc.videos).not_to eq [video_a, video_b]
      end

      it "returns videos sorted by popularity" do
        video_a = create(:video, popularity: 1)
        video_b = create(:video, popularity: 2)
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "videos.popularity",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "videos.popularity",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
        expect(search_asc.videos).not_to eq [video_a, video_b]
        expect(search_desc.videos).not_to eq [video_a, video_b]
      end

      it "returns videos sorted by updated_at" do
        video_a = create(:video)
        video_b = create(:video)
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "videos.updated_at",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "videos.updated_at",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_b, video_a]
        expect(search_desc.videos).to eq [video_b, video_a]
        expect(search_asc.videos).not_to eq [video_a, video_b]
        expect(search_desc.videos).not_to eq [video_a, video_b]
      end

      it "does not sort by parameter that's not a searchable column" do
        video_a = create(:video, title: "A")
        video_b = create(:video, title: "B")
        search_asc = described_class.new(filtering_params: {},
                                         sorting_params:   { sort:      "videos.title",
                                                             direction: "ASC" },
                                         page:             1)
        search_desc = described_class.new(filtering_params: {},
                                          sorting_params:   { sort:      "videos.title",
                                                              direction: "DESC" },
                                          page:             1)
        expect(search_asc.videos).to eq [video_a, video_b]
        expect(search_desc.videos).to eq [video_a, video_b]
        expect(search_asc.videos).not_to eq [video_b, video_a]
        expect(search_desc.videos).not_to eq [video_b, video_a]
        expect(search_asc.videos).not_to be_nil
        expect(search_desc.videos).not_to be_nil
      end
    end

    describe "filter_videos" do
      it "filters by leader_id" do
        leader = create(:leader)
        video_a = create(:video, leader: leader)
        video_b = create(:video)
        search = described_class.new(filtering_params: { leader_id: leader.id },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by follower_id" do
        follower = create(:follower)
        video_a = create(:video, follower: follower)
        video_b = create(:video)

        search = described_class.new(filtering_params: { follower_id: follower.id },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by channel_id" do
        channel = create(:channel)
        video_a = create(:video, channel: channel)
        video_b = create(:video)

        search = described_class.new(filtering_params: { channel_id: channel.id },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by genre" do
        song = create(:song, genre: "Tango")
        video_a = create(:video, song: song)
        video_b = create(:video)

        search = described_class.new(filtering_params: { genre: "Tango" },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by orchestra" do
        song = create(:song, artist: "Di Sarli")
        video_a = create(:video, song: song)
        video_b = create(:video)

        search = described_class.new(filtering_params: { orchestra: "Di Sarli" },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by song_id" do
        song = create(:song)
        video_a = create(:video, song: song)
        video_b = create(:video)

        search = described_class.new(filtering_params: { song_id: song.id },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by hd" do
        video_a = create(:video, hd: true)
        video_b = create(:video, hd: false)

        search_a = described_class.new(filtering_params: { hd: 1 },
                                       sorting_params:   { sort:      "videos.updated_at",
                                                           direction: "ASC" },
                                       page:             1)

        search_b = described_class.new(filtering_params: { hd: 0 },
                                       sorting_params:   { sort:      "videos.updated_at",
                                                           direction: "ASC" },
                                       page:             1)

        expect(search_a.videos).to eq [video_a]
        expect(search_a.videos).not_to eq [video_b]
        expect(search_b.videos).to eq [video_b]
        expect(search_b.videos).not_to eq [video_a]
      end

      it "filters by event_id" do
        event = create(:event)
        video_a = create(:video, event: event)
        video_b = create(:video)

        search = described_class.new(filtering_params: { event_id: event.id },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      it "filters by year" do
        video_a = create(:video, upload_date: Time.new(2018, 1, 1))
        video_b = create(:video)

        search = described_class.new(filtering_params: { year: "2018" },
                                     sorting_params:   { sort:      "videos.updated_at",
                                                         direction: "ASC" },
                                     page:             1)

        expect(search.videos).to eq [video_a]
        expect(search.videos).not_to eq [video_b]
      end

      describe "filter_by_query" do
        it "returns video with title that matches query" do
          video = create(:video, title: "Title with carlitos espinoza")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with description that matches query" do
          video = create(:video, description: "description with carlitos espinoza")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with leader name that matches query" do
          leader = create(:leader, name: "Carlitos Espinoza")
          video = create(:video, leader: leader)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with leader nickname that matches query" do
          leader = create(:leader, nickname: "Carlitos")
          video = create(:video, leader: leader)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Carlitos" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "no match" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Carlit" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with follower name that matches query" do
          follower = create(:follower, name: "Noelia Hurtado")
          video = create(:video, follower: follower)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Noelia Hurtado" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "noeli" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with follower nickname that matches query" do
          follower = create(:follower, nickname: "Noelia")
          video = create(:video, follower: follower)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Noelia" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Noel" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_id that matches query" do
          video = create(:video, youtube_id: "s6iptZdCcG0")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "s6iptZdCcG0" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "s6iptZdCcG" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_artist that matches query" do
          video = create(:video, youtube_artist: "Angel D'Agostino")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "Agostino" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Agostin" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with youtube_song that matches query" do
          video = create(:video, youtube_song: "No Vendrá")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "no vendrá" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "no vend" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with spotify_track_name that matches query" do
          video = create(:video, spotify_track_name: "No Vendrá")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "no vendrá" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "no vend" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with spotify_artist_name that matches query" do
          video = create(:video, spotify_artist_name: "Angel D'Agostino")
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "agostino" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Angel D'Agosti" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with channel title that matches query" do
          channel = create(:channel, title: "030 Tango")
          video = create(:video, channel: channel)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "030 tango" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "030 T" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with channel_id that matches query" do
          channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
          video = create(:video, channel: channel)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "UCtdgMR0bmogczrZNpPaO66Q" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "UCtdgMR0bmogczrZNpPaO" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song genre that matches query" do
          song = create(:song, genre: "Tango")
          video = create(:video, song: song)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "tango" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "tang" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song title that matches query" do
          song = create(:song, title: "La Mentirosa")
          video = create(:video, song: song)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "mentirosa" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "menti" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end

        it "returns video with song artist that matches query" do
          song = create(:song, artist: "Angel D'Agostino")
          video = create(:video, song: song)
          VideosSearch.refresh
          search_a = described_class.new(filtering_params: { query: "d'agostino" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "ASC" },
                                         page:             1)
          search_b = described_class.new(filtering_params: { query: "John Doe" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          search_c = described_class.new(filtering_params: { query: "Agosti" },
                                         sorting_params:   { sort:      "videos.upload_date",
                                                             direction: "DESC" },
                                         page:             1)
          expect(search_a.videos).to eq [video]
          expect(search_b.videos).not_to eq [video]
          expect(search_c.videos).to eq [video]
        end
      end
    end

    describe "#paginated_videos" do
      it "paginates videos by 60" do
        create_list(:video, 61)
        page1 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             2)
        page3 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             3)
        page4 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             4)
        expect(page1.paginated_videos.count).to eq(60)
        expect(page2.paginated_videos.count).to eq(1)
        expect(page3.paginated_videos.count).to eq(0)
      end
    end

    describe "#displayed_videos_count" do
      it "counts the total amount of displayed videos" do
        create_list(:video, 61)
        page1 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             2)
        page3 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             3)
        page4 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             4)
        expect(page1.displayed_videos_count).to eq(60)
        expect(page2.displayed_videos_count).to eq(61)
        expect(page3.displayed_videos_count).to eq(61)
      end
    end

    describe "#next_page" do
      it "returns the next page" do
        create_list(:video, 80)
        page1 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sorting_params:   { sort:      "videos.upload_date",
                                                        direction: "ASC" },
                                    page:             2)

        expect(page1.next_page.any?).to eq(true)
        expect(page2.next_page.any?).to eq(false)
      end
    end

    describe "#leaders" do
      it "returns leader options" do
        leader = create(:leader, name: "Carlitos Espinoza")
        create(:video, leader: leader)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.leaders).to eq([["Carlitos Espinoza (1)", leader.id]])
      end

      it "does not duplicate with same leader and increments count" do
        leader = create(:leader, name: "Carlitos Espinoza")
        create(:video, leader: leader)
        create(:video, leader: leader)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.leaders).to eq([["Carlitos Espinoza (2)", leader.id]])
      end

      it "creates array of leaders and increments multiple videos without duplication" do
        leader = create(:leader, name: "Carlitos Espinoza")
        leader2 = create(:leader, name: "Sebastian Jimenez")
        create(:video, leader: leader)
        create(:video, leader: leader2)
        create(:video, leader: leader2)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.leaders).to eq([["Sebastian Jimenez (2)", leader2.id], ["Carlitos Espinoza (1)", leader.id]])
      end
    end

    describe "#followers" do
      it "returns follower options" do
        follower = create(:follower, name: "Noelia Hurtado")
        create(:video, follower: follower)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.followers).to eq([["Noelia Hurtado (1)", follower.id]])
      end

      it "does not duplicate with same follower and increments count" do
        follower = create(:follower, name: "Noelia Hurtado")
        create(:video, follower: follower)
        create(:video, follower: follower)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.followers).to eq([["Noelia Hurtado (2)", follower.id]])
      end

      it "creates array of followers and increments multiple videos without duplication" do
        follower = create(:follower, name: "Noelia Hurtado")
        follower2 = create(:follower, name: "Moira Castellano")
        create(:video, follower: follower)
        create(:video, follower: follower2)
        create(:video, follower: follower2)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.followers).to eq([["Moira Castellano (2)", follower2.id], ["Noelia Hurtado (1)", follower.id]])
      end
    end

    describe "#orchestras" do
      it "returns orchestra options" do
        song = create(:song, artist: "Carlos Di Sarli")
        create(:video, song: song)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.orchestras).to eq([["Carlos Di Sarli (1)", "carlos di sarli"]])
      end

      it "does not duplicate with same orchestra and increments count" do
        song = create(:song, artist: "Carlos Di Sarli")
        create(:video, song: song)
        create(:video, song: song)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.orchestras).to eq([["Carlos Di Sarli (2)", "carlos di sarli"]])
      end

      it "creates array of ors and increments multiple videos without duplication" do
        song = create(:song, artist: "Carlos Di Sarli")
        song2 = create(:song, artist: "Osvaldo Pugliese")
        create(:video, song: song)
        create(:video, song: song2)
        create(:video, song: song2)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.orchestras).to eq([["Osvaldo Pugliese (2)", "osvaldo pugliese"], ["Carlos Di Sarli (1)", "carlos di sarli"]])
      end
    end

    describe "#genre" do
      it "returns song options" do
        song = create(:song, genre: "Milonga")
        create(:video, song: song)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.genres).to eq([["Milonga (1)", "milonga"]])
      end

      it "does not duplicate with same song and increments count" do
        song = create(:song, genre: "Milonga")
        create(:video, song: song)
        create(:video, song: song)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.genres).to eq([["Milonga (2)", "milonga"]])
      end

      it "creates array of songs and increments multiple videos without duplication" do
        song = create(:song, genre: "Milonga")
        song2 = create(:song, genre: "Tango")
        create(:video, song: song)
        create(:video, song: song2)
        create(:video, song: song2)

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.genres).to eq([["Tango (2)", "tango"], ["Milonga (1)", "milonga"]])
      end
    end

    describe "#years" do
      it "returns year options" do
        create(:video, upload_date: Time.new(2018, 1, 1))

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.years).to eq([["2018 (1)", 2018]])
      end

      it "does not duplicate with same song and increments count" do
        create(:video, upload_date: Time.new(2018, 1, 1))
        create(:video, upload_date: Time.new(2018, 1, 1))

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.years).to eq([["2018 (2)", 2018]])
      end

      it "creates array of songs and increments multiple videos without duplication" do
        create(:video, upload_date: Time.new(2018, 1, 1))
        create(:video, upload_date: Time.new(2018, 1, 1))
        create(:video, upload_date: Time.new(2017, 1, 1))

        search = described_class.new(filtering_params: {},
                                     sorting_params:   { sort:      "videos.upload_date",
                                                         direction: "ASC" },
                                     page:             1)
        expect(search.years).to eq([["2018 (2)", 2018], ["2017 (1)", 2017]])
      end
    end
  end
end
