# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::FacetBuilder do
  fixtures :all

  describe "#select_facet_counts" do
    it "returns a leader facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).leaders
      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Carlitos Espinoza", count: 2, param: "leader", value: "carlitos-espinoza"),
        Video::FacetBuilder::Facet.new(name: "Corina Herrera", count: 1, param: "leader", value: "corina-herrera"),
        Video::FacetBuilder::Facet.new(name: "Gianpiero Ya Galdi", count: 1, param: "leader", value: "gianpiero-ya-galdi"),
        Video::FacetBuilder::Facet.new(name: "Jonathan Saavedra", count: 1, param: "leader", value: "jonathan-saavedra"),
        Video::FacetBuilder::Facet.new(name: "Octavio Fernandez", count: 1, param: "leader", value: "octavio-fernandez")
      ]

      expect(facet).to eq expected_output
    end
  end

  describe "#followers" do
    it "returns a follower facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).followers
      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Noelia Hurtado", count: 2, param: "follower", value: "noelia-hurtado"),
        Video::FacetBuilder::Facet.new(name: "Clarisa Aragon", count: 1, param: "follower", value: "clarisa-aragon"),
        Video::FacetBuilder::Facet.new(name: "Corina Herrera", count: 1, param: "follower", value: "corina-herrera"),
        Video::FacetBuilder::Facet.new(name: "Inez Muzzopapa", count: 1, param: "follower", value: "inez-muzzopapa"),
        Video::FacetBuilder::Facet.new(name: "Lorena Tarrantino", count: 1, param: "follower", value: "lorena-tarrantino")
      ]

      expect(facet).to eq expected_output
    end

    it "returns a follower facet for videos when filtering for a leader" do
      video_relation = Video::Filter.new(Video.all, filtering_params: {leader: "corina-herrera"}).apply_filter

      facet_builder = Video::FacetBuilder.new(video_relation)
      facet = facet_builder.followers

      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Inez Muzzopapa", count: 1, param: "follower", value: "inez-muzzopapa")
      ]

      expect(facet).to eq(expected_output)
    end
  end

  describe "#orchestras" do
    it "returns an orchestra facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).orchestras
      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Juan D'Arienzo", count: 3, param: "orchestra", value: "juan-darienzo"),
        Video::FacetBuilder::Facet.new(name: "Alberto Castillo", count: 1, param: "orchestra", value: "alberto-castillo"),
        Video::FacetBuilder::Facet.new(name: "Carlos Di Sarli", count: 1, param: "orchestra", value: "carlos-di-sarli"),
        Video::FacetBuilder::Facet.new(name: "Osvaldo Pugliese", count: 1, param: "orchestra", value: "osvaldo-pugliese")
      ]

      expect(facet).to eq expected_output
    end
  end

  describe "#genres" do
    it "returns a genre facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).genres

      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Tango", count: 4, param: "genre", value: "tango"),
        Video::FacetBuilder::Facet.new(name: "Milonga", count: 1, param: "genre", value: "milonga"),
        Video::FacetBuilder::Facet.new(name: "Vals", count: 1, param: "genre", value: "vals")
      ]

      expect(facet).to eq expected_output
    end
  end

  describe "#years" do
    it "returns a year facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).years

      expected_output = [
        Video::FacetBuilder::Facet.new(name: 2020, count: 2, param: "year", value: 2020),
        Video::FacetBuilder::Facet.new(name: 2021, count: 1, param: "year", value: 2021),
        Video::FacetBuilder::Facet.new(name: 2018, count: 1, param: "year", value: 2018),
        Video::FacetBuilder::Facet.new(name: 2014, count: 1, param: "year", value: 2014),
        Video::FacetBuilder::Facet.new(name: 2013, count: 1, param: "year", value: 2013)
      ]

      expect(facet).to eq expected_output
    end
  end

  describe "#songs" do
    it "returns a song facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).songs

      expected_output = [
        Video::FacetBuilder::Facet.new(name: "Nueve De Julio", count: 2, param: "song", value: "nueve-de-julio-juan-darienzo"),
        Video::FacetBuilder::Facet.new(name: "Cuando El Amor Muere", count: 1, param: "song", value: "cuando-el-amor-muere-carlos-di-sarli"),
        Video::FacetBuilder::Facet.new(name: "Malandraca", count: 1, param: "song", value: "malandraca-osvaldo-pugliese"),
        Video::FacetBuilder::Facet.new(name: "Milonga Querida", count: 1, param: "song", value: "milonga-querida-juan-darienzo"),
        Video::FacetBuilder::Facet.new(name: "Violetas", count: 1, param: "song", value: "violetas-aberto-castillo")
      ]

      expect(facet).to eq expected_output
    end
  end
end
