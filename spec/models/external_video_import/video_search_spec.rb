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
          ["Carlitos Espinoza (1)", "carlitos-espinoza"],
          ["Gianpiero Ya Galdi (1)", "gianpiero-ya-galdi"],
          ["Jonathan Saavedra (1)", "jonathan-saavedra"],
          ["Octavio Fernandez (1)", "octavio-fernandez"]
        ],
        followers: [
          ["Clarisa Aragon (1)", "clarisa-aragon"],
          ["Corina Herrera (1)", "corina-herrera"],
          ["Lorena Tarrantino (1)", "lorena-tarrantino"],
          ["Noelia Hurtado (1)", "noelia-hurtado"]
        ],
        orchestras: [
          ["Carlos Di Sarli (1)", "carlos-di-sarli"],
          ["Juan D'Arienzo (2)", "juan-d'arienzo"],
          ["Osvaldo Pugliese (1)", "osvaldo-pugliese"]
        ],
        genres: [["Tango (4)", "tango"]],
        years: [
          ["2014 (1)", "2014"],
          ["2018 (1)", "2018"],
          ["2020 (1)", "2020"],
          ["2021 (1)", "2021"]
        ],
        songs: [
          ["Cuando El Amor Muere (1)", "cuando-el-amor-muere"],
          ["Malandraca (1)", "malandraca"],
          ["Nueve De Julio (2)", "nueve-de-julio"]
        ]
      }
    end

    it "returns facet values" do
      facet_mappings.each do |facet_name, expected_values|
        result = VideoSearch.new(filtering_params:, sorting_params:).send(facet_name)

        expect(result).to contain_exactly(*expected_values)
      end
    end
  end
end
