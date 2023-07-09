# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::FacetBuilder do
  fixtures :all

  describe "#leaders" do
    it "returns a leader facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).leaders
      expected_output = Video::FacetBuilder::Facet.new(
        name: "leader",
        options: [
          Video::FacetBuilder::Option.new(value: "carlitos-espinoza", label: "Carlitos Espinoza (2)"),
          Video::FacetBuilder::Option.new(value: "corina-herrera", label: "Corina Herrera (1)"),
          Video::FacetBuilder::Option.new(value: "gianpiero-ya-galdi", label: "Gianpiero Ya Galdi (1)"),
          Video::FacetBuilder::Option.new(value: "jonathan-saavedra", label: "Jonathan Saavedra (1)"),
          Video::FacetBuilder::Option.new(value: "octavio-fernandez", label: "Octavio Fernandez (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end

  describe "#followers" do
    it "returns a follower facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).followers
      expected_output = Video::FacetBuilder::Facet.new(
        name: "follower",
        options: [
          Video::FacetBuilder::Option.new(value: "noelia-hurtado", label: "Noelia Hurtado (2)"),
          Video::FacetBuilder::Option.new(value: "clarisa-aragon", label: "Clarisa Aragon (1)"),
          Video::FacetBuilder::Option.new(value: "corina-herrera", label: "Corina Herrera (1)"),
          Video::FacetBuilder::Option.new(value: "inez-muzzopapa", label: "Inez Muzzopapa (1)"),
          Video::FacetBuilder::Option.new(value: "lorena-tarrantino", label: "Lorena Tarrantino (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end

  describe "#orchestras" do
    it "returns an orchestra facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).orchestras
      expected_output = Video::FacetBuilder::Facet.new(
        name: "orchestra",
        options: [
          Video::FacetBuilder::Option.new(value: "juan-darienzo", label: "Juan D'Arienzo (3)"),
          Video::FacetBuilder::Option.new(value: "alberto-castillo", label: "Alberto Castillo (1)"),
          Video::FacetBuilder::Option.new(value: "carlos-di-sarli", label: "Carlos Di Sarli (1)"),
          Video::FacetBuilder::Option.new(value: "osvaldo-pugliese", label: "Osvaldo Pugliese (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end

  describe "#genres" do
    it "returns a genre facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).genres
      expected_output = Video::FacetBuilder::Facet.new(
        name: "genre",
        options: [
          Video::FacetBuilder::Option.new(value: "tango", label: "Tango (4)"),
          Video::FacetBuilder::Option.new(value: "milonga", label: "Milonga (1)"),
          Video::FacetBuilder::Option.new(value: "vals", label: "Vals (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end

  describe "#years" do
    it "returns a year facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).years
      expected_output = Video::FacetBuilder::Facet.new(
        name: "year",
        options: [
          Video::FacetBuilder::Option.new(value: 2020, label: "2020 (2)"),
          Video::FacetBuilder::Option.new(value: 2021, label: "2021 (1)"),
          Video::FacetBuilder::Option.new(value: 2018, label: "2018 (1)"),
          Video::FacetBuilder::Option.new(value: 2014, label: "2014 (1)"),
          Video::FacetBuilder::Option.new(value: 2013, label: "2013 (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end

  describe "#songs" do
    it "returns a song facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).songs
      expected_output = Video::FacetBuilder::Facet.new(
        name: "song",
        options: [
          Video::FacetBuilder::Option.new(value: "nueve-de-julio-juan-darienzo", label: "Nueve De Julio (2)"),
          Video::FacetBuilder::Option.new(value: "cuando-el-amor-muere-carlos-di-sarli", label: "Cuando El Amor Muere (1)"),
          Video::FacetBuilder::Option.new(value: "malandraca-osvaldo-pugliese", label: "Malandraca (1)"),
          Video::FacetBuilder::Option.new(value: "milonga-querida-juan-darienzo", label: "Milonga Querida (1)"),
          Video::FacetBuilder::Option.new(value: "violetas-aberto-castillo", label: "Violetas (1)")
        ]
      )

      expect(facet).to eq(expected_output)
    end
  end
end
