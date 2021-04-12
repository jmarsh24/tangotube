require "rails_helper"

RSpec.describe Video::Search, type: :model do
  describe "#all_videos" do
    describe "sorting" do
      it "returns a videos sorted by songs.last_name_search" do
        song_a = create(:song, last_name_search: "A")
        song_b = create(:song, last_name_search: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc = described_class.new(filtering_params: {}, sort_column: "songs.last_name_search", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "songs.last_name_search", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end

      it "returns a videos sorted by songs.title" do
        song_a = create(:song, title: "A")
        song_b = create(:song, title: "B")
        video_a = create(:video, song: song_a)
        video_b = create(:video, song: song_b)
        search_asc = described_class.new(filtering_params: {}, sort_column: "songs.title", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "songs.title", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end

      it "returns a videos sorted by title ASC" do
        video_a = create(:video, title: "A")
        video_b = create(:video, title: "B")
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.title", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.title", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end

      it "returns a videos sorted by upload_date" do
        video_a = create(:video, upload_date: Time.new(2020, 1, 1))
        video_b = create(:video, upload_date: Time.new(2019, 1, 1))
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.upload_date", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.upload_date", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_b, video_a]
        expect(search_desc.all_videos).to eq [video_a, video_b]
        expect(search_asc.all_videos).not_to eq [video_a, video_b]
        expect(search_desc.all_videos).not_to eq [video_b, video_a]
      end

      it "returns a videos sorted by view_count" do
        video_a = create(:video, view_count: 1)
        video_b = create(:video, view_count: 2)
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.view_count", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.view_count", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end

      it "returns a videos sorted by popularity" do
        video_a = create(:video, popularity: 1)
        video_b = create(:video, popularity: 2)
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.popularity", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.popularity", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end

      it "returns a videos sorted by updated_at" do
        video_a = create(:video)
        video_b = create(:video)
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.updated_at", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.updated_at", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end
    end

    describe "filter_videos" do
      it "returns a videos sorted by updated_at" do
        video_a = create(:video)
        video_b = create(:video)
        search_asc = described_class.new(filtering_params: {}, sort_column: "videos.updated_at", sort_direction: "ASC", page: 1)
        search_desc = described_class.new(filtering_params: {}, sort_column: "videos.updated_at", sort_direction: "DESC", page: 1)
        expect(search_asc.all_videos).to eq [video_a, video_b]
        expect(search_desc.all_videos).to eq [video_b, video_a]
        expect(search_asc.all_videos).not_to eq [video_b, video_a]
        expect(search_desc.all_videos).not_to eq [video_a, video_b]
      end
    end

    it "filters by leader_id" do
      leader = create(:leader)
      video_a = create(:video, leader: leader)
      video_b = create(:video)
      search = described_class.new(filtering_params: { leader_id: leader.id },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by follower_id" do
      follower = create(:follower)
      video_a = create(:video, follower: follower)
      video_b = create(:video)

      search = described_class.new(filtering_params: { follower_id: follower.id },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by channel_id" do
      channel = create(:channel)
      video_a = create(:video, channel: channel)
      video_b = create(:video)

      search = described_class.new(filtering_params: { channel_id: channel.id },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by genre" do
      song = create(:song, genre: "Tango")
      video_a = create(:video, song: song)
      video_b = create(:video)

      search = described_class.new(filtering_params: { genre: "Tango" },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by orchestra" do
      song = create(:song, artist: "Di Sarli")
      video_a = create(:video, song: song)
      video_b = create(:video)

      search = described_class.new(filtering_params: { orchestra: "Di Sarli" },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by song_id" do
      song = create(:song)
      video_a = create(:video, song: song)
      video_b = create(:video)

      search = described_class.new(filtering_params: { song_id: song.id },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by hd" do
      video_a = create(:video, hd: true)
      video_b = create(:video, hd: false)

      search_a = described_class.new(filtering_params: { hd: 1 },
                                     sort_column:      "videos.updated_at",
                                     sort_direction:   "ASC",
                                     page:             1)

      search_b = described_class.new(filtering_params: { hd: 0 },
                                     sort_column:      "videos.updated_at",
                                     sort_direction:   "ASC",
                                     page:             1)

      expect(search_a.all_videos).to eq [video_a]
      expect(search_a.all_videos).not_to eq [video_b]
      expect(search_b.all_videos).to eq [video_b]
      expect(search_b.all_videos).not_to eq [video_a]
    end

    it "filters by event_id" do
      event = create(:event)
      video_a = create(:video, event: event)
      video_b = create(:video)

      search = described_class.new(filtering_params: { event_id: event.id },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    it "filters by year" do
      video_a = create(:video, upload_date: Time.new(2018, 1, 1))
      video_b = create(:video)

      search = described_class.new(filtering_params: { year: "2018" },
                                   sort_column:      "videos.updated_at",
                                   sort_direction:   "ASC",
                                   page:             1)

      expect(search.all_videos).to eq [video_a]
      expect(search.all_videos).not_to eq [video_b]
    end

    describe ".filter_by_query" do
      it "returns video with title that matches query" do
        video = create(:video, title: "Title with carlitos espinoza")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with description that matches query" do
        video = create(:video, description: "description with carlitos espinoza")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with leader name that matches query" do
        leader = create(:leader, name: "Carlitos Espinoza")
        video = create(:video, leader: leader)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Carlitos Espinoza" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Carlitos Espin" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with leader nickname that matches query" do
        leader = create(:leader, nickname: "Carlitos")
        video = create(:video, leader: leader)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Carlitos" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "no match" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Carlit" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with follower name that matches query" do
        follower = create(:follower, name: "Noelia Hurtado")
        video = create(:video, follower: follower)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Noelia Hurtado" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "noeli" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with follower nickname that matches query" do
        follower = create(:follower, nickname: "Noelia")
        video = create(:video, follower: follower)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Noelia" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Noel" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with youtube_id that matches query" do
        video = create(:video, youtube_id: "s6iptZdCcG0")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "s6iptZdCcG0" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "s6iptZdCcG" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with youtube_artist that matches query" do
        video = create(:video, youtube_artist: "Angel D'Agostino")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "Agostino" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Agostin" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with youtube_song that matches query" do
        video = create(:video, youtube_song: "No Vendrá")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "no vendrá" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "no vend" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with spotify_track_name that matches query" do
        video = create(:video, spotify_track_name: "No Vendrá")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "no vendrá" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "no vend" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with spotify_artist_name that matches query" do
        video = create(:video, spotify_artist_name: "Angel D'Agostino")
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "agostino" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Angel D'Agosti" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with channel title that matches query" do
        channel = create(:channel, title: "030 Tango")
        video = create(:video, channel: channel)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "030 tango" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "030 T" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with channel_id that matches query" do
        channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
        video = create(:video, channel: channel)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "UCtdgMR0bmogczrZNpPaO66Q" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "UCtdgMR0bmogczrZNpPaO" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with song genre that matches query" do
        song = create(:song, genre: "Tango")
        video = create(:video, song: song)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "tango" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "tang" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with song title that matches query" do
        song = create(:song, title: "La Mentirosa")
        video = create(:video, song: song)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "mentirosa" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "menti" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end

      it "returns video with song artist that matches query" do
        song = create(:song, artist: "Angel D'Agostino")
        video = create(:video, song: song)
        VideosSearch.refresh
        search_a = described_class.new(filtering_params: { query: "d'agostino" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
        search_b = described_class.new(filtering_params: { query: "John Doe" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        search_c = described_class.new(filtering_params: { query: "Agosti" },
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "DESC",
                                       page:             1)
        expect(search_a.all_videos).to eq [video]
        expect(search_b.all_videos).not_to eq [video]
        expect(search_c.all_videos).to eq [video]
      end
    end

    describe "#videos" do
      it "paginates videos by 60" do
        create_list(:video, 150)
        page1 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             2)
        page3 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             3)
        page4 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             4)
        expect(page1.videos.count).to eq(60)
        expect(page2.videos.count).to eq(60)
        expect(page3.videos.count).to eq(30)
        expect(page4.videos.count).to eq(0)
      end
    end

    describe "#displayed_videos_count" do
      it "counts the total amount of displayed videos" do
        create_list(:video, 150)
        page1 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             2)
        page3 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             3)
        page4 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             4)
        expect(page1.displayed_videos_count).to eq(60)
        expect(page2.displayed_videos_count).to eq(120)
        expect(page3.displayed_videos_count).to eq(150)
        expect(page4.displayed_videos_count).to eq(150)
      end
    end

    describe "#next_page" do
      it "returns the next page" do
        create_list(:video, 80)
        page1 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             1)
        page2 = described_class.new(filtering_params: {},
                                    sort_column:      "videos.upload_date",
                                    sort_direction:   "ASC",
                                    page:             2)

        expect(page1.next_page.any?).to eq(true)
        expect(page2.next_page.any?).to eq(false)
      end
    end

    describe "#leaders" do
      it "returns leaders options" do
        leader = create(:leader, name: "Carlitos Espinoza")
        create(:video, leader: leader)

        search = described_class.new(filtering_params: {},
                                     sort_column:      "videos.upload_date",
                                     sort_direction:   "ASC",
                                     page:             1)
        expect(search.leaders).to eq([["Carlitos Espinoza (1)", leader.id]])
      end
    end

    describe "#followers" do
      it "returns followers options" do
        follower = create(:follower, name: "Noelia Hurtado")
        create(:video, follower: follower)

        search = described_class.new(filtering_params: {},
                                     sort_column:      "videos.upload_date",
                                     sort_direction:   "ASC",
                                     page:             1)
        expect(search.followers).to eq([["Noelia Hurtado (1)", follower.id]])
      end

      describe "#orchestras" do
        it "returns orchestras options" do
          song = create(:song, artist: "Carlos Di Sarli")
          create(:video, song: song)

          search = described_class.new(filtering_params: {},
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
          expect(search.orchestras).to eq([["Carlos Di Sarli (1)", "carlos di sarli"]])
        end
      end

      describe "#orchestras" do
        it "returns orchestras options" do
          song = create(:song, genre: "Tango")
          create(:video, song: song)

          search = described_class.new(filtering_params: {},
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
          expect(search.genres).to eq([["Tango (1)", "tango"]])
        end
      end

      describe "#years" do
        it "returns years options" do
          create(:video, upload_date: Time.new(2018, 1, 1))

          search = described_class.new(filtering_params: {},
                                       sort_column:      "videos.upload_date",
                                       sort_direction:   "ASC",
                                       page:             1)
          expect(search.years).to eq([["2018 (1)", 2018]])
        end
      end
    end
  end
end
