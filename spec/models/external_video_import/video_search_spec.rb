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

      expect(result).to contain_exactly(videos(:video_4_featured))
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
          ["Clarisa Aragon (1)", "clarisa-aragon"],
          ["Corina Herrera (1)", "corina-herrera"],
          ["Inez Muzzopapa (1)", "inez-muzzopapa"],
          ["Lorena Tarrantino (1)", "lorena-tarrantino"],
          ["Noelia Hurtado (2)", "noelia-hurtado"]
        ],
        orchestras: [
          ["Alberto Castillo (1)", "alberto-castillo"],
          ["Carlos Di Sarli (1)", "carlos-di-sarli"],
          ["Juan D'Arienzo (3)", "juan-d'arienzo"],
          ["Osvaldo Pugliese (1)", "osvaldo-pugliese"]
        ],
        genres: [
          ["Milonga (1)", "milonga"],
          ["Tango (4)", "tango"],
          ["Vals (1)", "vals"]
        ],
        years: [
          ["2013 (1)", "2013"],
          ["2014 (1)", "2014"],
          ["2018 (1)", "2018"],
          ["2020 (2)", "2020"],
          ["2021 (1)", "2021"]
        ],
        songs: [
          ["Cuando El Amor Muere (1)", "cuando-el-amor-muere"],
          ["Malandraca (1)", "malandraca"],
          ["Milonga Querida (1)", "milonga-querida"],
          ["Nueve De Julio (2)", "nueve-de-julio"],
          ["Violetas (1)", "violetas"]
        ]
      }
    end

    it "returns facet values" do
      filtering_params = {}

      facet_mappings.each do |facet_name, expected_values|
        result = VideoSearch.new(filtering_params:, sorting_params:).send(facet_name)

        expect(result).to contain_exactly(*expected_values)
      end
    end

    it "returns facet values when filtering for a year" do
      filtering_params = {year: "2020"}

      result = VideoSearch.new(filtering_params:, sorting_params:)

      expect(result.years).to contain_exactly(["2020 (2)", "2020"])
      expect(result.leaders).to contain_exactly(["Corina Herrera (1)", "corina-herrera"], ["Gianpiero Ya Galdi (1)", "gianpiero-ya-galdi"])
      expect(result.followers).to contain_exactly(["Inez Muzzopapa (1)", "inez-muzzopapa"], ["Lorena Tarrantino (1)", "lorena-tarrantino"])
      expect(result.orchestras).to contain_exactly(["Juan D'Arienzo (2)", "juan-d'arienzo"])
      expect(result.songs).to contain_exactly(["Milonga Querida (1)", "milonga-querida"], ["Nueve De Julio (1)", "nueve-de-julio"])
      expect(result.genres).to contain_exactly(["Milonga (1)", "milonga"], ["Tango (1)", "tango"])
    end
  end
end
