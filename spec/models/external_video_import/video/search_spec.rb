# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Search do
  fixtures :all

  describe "#perform_search" do
    context "when not searching for anything" do
      it "returns all videos with facets" do
        leader_facet = [
          Video::FacetBuilder::Facet.new(name: "Carlitos Espinoza", count: 2, param: "leader", value: "carlitos-espinoza"),
          Video::FacetBuilder::Facet.new(name: "Corina Herrera", count: 1, param: "leader", value: "corina-herrera"),
          Video::FacetBuilder::Facet.new(name: "Gianpiero Ya Galdi", count: 1, param: "leader", value: "gianpiero-ya-galdi"),
          Video::FacetBuilder::Facet.new(name: "Jonathan Saavedra", count: 1, param: "leader", value: "jonathan-saavedra"),
          Video::FacetBuilder::Facet.new(name: "Octavio Fernandez", count: 1, param: "leader", value: "octavio-fernandez")
        ]

        follower_facet = [
          Video::FacetBuilder::Facet.new(name: "Noelia Hurtado", count: 2, param: "follower", value: "noelia-hurtado"),
          Video::FacetBuilder::Facet.new(name: "Clarisa Aragon", count: 1, param: "follower", value: "clarisa-aragon"),
          Video::FacetBuilder::Facet.new(name: "Corina Herrera", count: 1, param: "follower", value: "corina-herrera"),
          Video::FacetBuilder::Facet.new(name: "Inez Muzzopapa", count: 1, param: "follower", value: "inez-muzzopapa"),
          Video::FacetBuilder::Facet.new(name: "Lorena Tarrantino", count: 1, param: "follower", value: "lorena-tarrantino")
        ]

        orchestra_facet = [
          Video::FacetBuilder::Facet.new(name: "Juan D'Arienzo", count: 3, param: "orchestra", value: "juan-darienzo"),
          Video::FacetBuilder::Facet.new(name: "Alberto Castillo", count: 1, param: "orchestra", value: "alberto-castillo"),
          Video::FacetBuilder::Facet.new(name: "Carlos Di Sarli", count: 1, param: "orchestra", value: "carlos-di-sarli"),
          Video::FacetBuilder::Facet.new(name: "Osvaldo Pugliese", count: 1, param: "orchestra", value: "osvaldo-pugliese")
        ]

        genre_facet = [
          Video::FacetBuilder::Facet.new(name: "Tango", count: 4, param: "genre", value: "tango"),
          Video::FacetBuilder::Facet.new(name: "Milonga", count: 1, param: "genre", value: "milonga"),
          Video::FacetBuilder::Facet.new(name: "Vals", count: 1, param: "genre", value: "vals")
        ]

        year_facet = [
          Video::FacetBuilder::Facet.new(name: 2020, count: 2, param: "year", value: 2020),
          Video::FacetBuilder::Facet.new(name: 2021, count: 1, param: "year", value: 2021),
          Video::FacetBuilder::Facet.new(name: 2018, count: 1, param: "year", value: 2018),
          Video::FacetBuilder::Facet.new(name: 2014, count: 1, param: "year", value: 2014),
          Video::FacetBuilder::Facet.new(name: 2013, count: 1, param: "year", value: 2013)
        ]

        song_facet = [
          Video::FacetBuilder::Facet.new(name: "Nueve De Julio", count: 2, param: "song", value: "nueve-de-julio-juan-darienzo"),
          Video::FacetBuilder::Facet.new(name: "Cuando El Amor Muere", count: 1, param: "song", value: "cuando-el-amor-muere-carlos-di-sarli"),
          Video::FacetBuilder::Facet.new(name: "Malandraca", count: 1, param: "song", value: "malandraca-osvaldo-pugliese"),
          Video::FacetBuilder::Facet.new(name: "Milonga Querida", count: 1, param: "song", value: "milonga-querida-juan-darienzo"),
          Video::FacetBuilder::Facet.new(name: "Violetas", count: 1, param: "song", value: "violetas-aberto-castillo")
        ]

        facets = Video::Search::Facets.new(leaders: leader_facet, followers: follower_facet, orchestras: orchestra_facet, genres: genre_facet, years: year_facet, songs: song_facet)

        search = Video::Search.new

        expect(search.perform_search).to match_array(Video.all.order(popularity: :desc))

        expect(search.facets).to eq(facets)
      end

      it "returns all videos when filtering with leader and sorting" do
        leader_facet = [
          Video::FacetBuilder::Facet.new(name: "Corina Herrera", count: 1, param: "leader", value: "corina-herrera"),
        ]

        follower_facet = [
          Video::FacetBuilder::Facet.new(name: "Inez Muzzopapa", count: 1, param: "follower", value: "inez-muzzopapa"),
        ]

        orchestra_facet = [
          Video::FacetBuilder::Facet.new(name: "Juan D'Arienzo", count: 1, param: "orchestra", value: "juan-darienzo"),
        ]

        genre_facet = [
          Video::FacetBuilder::Facet.new(name: "Milonga", count: 1, param: "genre", value: "milonga"),
        ]

        year_facet = [
          Video::FacetBuilder::Facet.new(name: 2020, count: 1, param: "year", value: 2020),
        ]

        song_facet = [
          Video::FacetBuilder::Facet.new(name: "Milonga Querida", count: 1, param: "song", value: "milonga-querida-juan-darienzo"),
        ]

        facets = Video::Search::Facets.new(leaders: leader_facet, followers: follower_facet, orchestras: orchestra_facet, genres: genre_facet, years: year_facet, songs: song_facet)

        search = Video::Search.new(filtering_params: {leader: "corina-herrera"})
        expected_videos = Video::Filter.new(Video.all, filtering_params: {leader: "corina-herrera"}).apply_filter

        expect(search.perform_search).to match_array(expected_videos)

        expect(search.facets).to eq(facets)
      end
    end
  end
end
