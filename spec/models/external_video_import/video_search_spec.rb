# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoSearch do
  fixtures :all

  let(:filtering_params) { {genre: "tango"} }

  let(:sorting_params) { {sort: "videos.popularity", direction: "desc"} }

  describe "#videos" do
    it "returns filtered and sorted videos" do
      filtering_params = {genre: "vals"}
      search = VideoSearch.new(filtering_params:, sorting_params:)
      result = search.videos

      expect(result).to match_array([videos(:video_4_featured)])
    end
  end

  describe "#facet" do
    let(:facet_mappings) do
      {
        leaders: [
          ["Carlitos Espinoza (2)", "carlitos-espinoza"],
          ["Corina Herrera (1)", "corina-herrera"],
          ["Gianpiero Ya Galdi (1)", "gianpiero-ya-galdi"],
          ["Jonathan Saavedra (1)", "jonathan-saavedra"],
          ["Octavio Fernandez (1)", "octavio-fernandez"]
        ],
        followers: [
          ["Noelia Hurtado (2)", "noelia-hurtado"],
          ["Clarisa Aragon (1)", "clarisa-aragon"],
          ["Corina Herrera (1)", "corina-herrera"],
          ["Inez Muzzopapa (1)", "inez-muzzopapa"],
          ["Lorena Tarrantino (1)", "lorena-tarrantino"]
        ],
        orchestras: [
          ["Juan D'Arienzo (3)", "juan-darienzo"],
          ["Alberto Castillo (1)", "alberto-castillo"],
          ["Carlos Di Sarli (1)", "carlos-di-sarli"],
          ["Osvaldo Pugliese (1)", "osvaldo-pugliese"]
        ],
        genres: [
          ["Tango (4)", "tango"],
          ["Milonga (1)", "milonga"],
          ["Vals (1)", "vals"]
        ],
        years: [
          ["2020 (2)", "2020"],
          ["2013 (1)", "2013"],
          ["2014 (1)", "2014"],
          ["2018 (1)", "2018"],
          ["2021 (1)", "2021"]
        ],
        songs: [
          ["Nueve De Julio (2)", "nueve-de-julio"],
          ["Cuando El Amor Muere (1)", "cuando-el-amor-muere"],
          ["Malandraca (1)", "malandraca"],
          ["Milonga Querida (1)", "milonga-querida"],
          ["Violetas (1)", "violetas"]
        ]
      }
    end

    it "returns facet values" do
      filtering_params = {}

      facet_mappings.each do |facet_name, expected_values|
        result = VideoSearch.new(filtering_params:, sorting_params:).send(facet_name)

        expect(result).to match_array(expected_values)
      end
    end

    it "returns facet values when filtering for a year" do
      filtering_params = {year: "2020"}

      result = VideoSearch.new(filtering_params:, sorting_params:)

      expect(result.years).to match_array([["2020 (2)", "2020"]])
      expect(result.leaders).to match_array([["Corina Herrera (1)", "corina-herrera"], ["Gianpiero Ya Galdi (1)", "gianpiero-ya-galdi"]])
      expect(result.followers).to match_array([["Inez Muzzopapa (1)", "inez-muzzopapa"], ["Lorena Tarrantino (1)", "lorena-tarrantino"]])
      expect(result.orchestras).to match_array([["Juan D'Arienzo (2)", "juan-darienzo"]])
      expect(result.songs).to match_array([["Milonga Querida (1)", "milonga-querida"], ["Nueve De Julio (1)", "nueve-de-julio"]])
      expect(result.genres).to match_array([["Milonga (1)", "milonga"], ["Tango (1)", "tango"]])
    end

    it "returns videos when filtering for a leader" do
      filtering_params = {leader: "carlitos-espinoza"}

      result = VideoSearch.new(filtering_params:, sorting_params:)

      expect(result.videos).to match_array([videos(:video_1_featured), videos(:video_4_featured)])
    end

    it "returns videos when filtering for an orchestra" do
      filtering_params = {orchestra: "juan-darienzo"}

      result = VideoSearch.new(filtering_params:, sorting_params:)

      expect(result.videos).to match_array([videos(:video_2_featured), videos(:video_3_featured), videos(:video_5)])
    end

    describe "#paginated_videos" do
      it "returns paginated videos" do
        search = VideoSearch.new(filtering_params:, sorting_params:)

        actual_ids = search.paginated_videos(1, per_page: 2).map(&:youtube_id)
        expected_ids = [videos(:video_3_featured), videos(:video_1_featured)].map(&:youtube_id)

        expect(actual_ids).to match_array(expected_ids)
      end
    end

    describe "#has_more_pages?" do
      it "returns true if there are more pages" do
        search = VideoSearch.new(filtering_params:, sorting_params:)

        expect(search.has_more_pages?(search.paginated_videos(1, per_page: 1))).to be true
      end

      it "returns false if there are no more pages" do
        search = VideoSearch.new(filtering_params:, sorting_params:)

        expect(search.has_more_pages?(search.paginated_videos(1, per_page: 5))).to be false
      end
    end

    describe "#next_page" do
      it "returns the next page number" do
        search = VideoSearch.new(filtering_params:, sorting_params:)

        expect(search.next_page(search.paginated_videos(1, per_page: 1))).to eq(2)
      end
    end

    describe "#featured_videos" do
      it "returns featured videos" do
        search = VideoSearch.new(filtering_params:, sorting_params:)

        expect(search.featured_videos(4)).to match_array([videos(:video_1_featured), videos(:video_2_featured), videos(:video_3_featured), videos(:video_4_featured)])
      end
    end
  end
end
