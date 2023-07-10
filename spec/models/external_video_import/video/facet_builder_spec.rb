# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::FacetBuilder do
  fixtures :all

  describe "#leaders" do
    fit "returns a leader facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).leader
      expected_options = [
        Video::FacetBuilder::Option.new(value: "carlitos-espinoza", label: "Carlitos Espinoza", count: 2),
        Video::FacetBuilder::Option.new(value: "corina-herrera", label: "Corina Herrera", count: 1),
        Video::FacetBuilder::Option.new(value: "gianpiero-ya-galdi", label: "Gianpiero Ya Galdi", count: 1),
        Video::FacetBuilder::Option.new(value: "jonathan-saavedra", label: "Jonathan Saavedra", count: 1),
        Video::FacetBuilder::Option.new(value: "octavio-fernandez", label: "Octavio Fernandez", count: 1)
      ]

      expect(facet.name).to eq("leader")
      expect(facet.options).to eq(expected_options)
    end
  end

  describe "#followers" do
    fit "returns a follower facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).follower
      expected_options = [
        Video::FacetBuilder::Option.new(value: "noelia-hurtado", label: "Noelia Hurtado", count: 2),
        Video::FacetBuilder::Option.new(value: "clarisa-aragon", label: "Clarisa Aragon", count: 1),
        Video::FacetBuilder::Option.new(value: "corina-herrera", label: "Corina Herrera", count: 1),
        Video::FacetBuilder::Option.new(value: "inez-muzzopapa", label: "Inez Muzzopapa", count: 1),
        Video::FacetBuilder::Option.new(value: "lorena-tarrantino", label: "Lorena Tarrantino", count: 1)
      ]

      expect(facet.name).to eq("follower")
      expect(facet.options).to eq(expected_options)
    end
  end

  describe "#orchestras" do
    fit "returns an orchestra facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).orchestra
      expected_options = [
        Video::FacetBuilder::Option.new(value: "juan-darienzo", label: "Juan D'Arienzo", count: 3),
        Video::FacetBuilder::Option.new(value: "alberto-castillo", label: "Alberto Castillo", count: 1),
        Video::FacetBuilder::Option.new(value: "carlos-di-sarli", label: "Carlos Di Sarli", count: 1),
        Video::FacetBuilder::Option.new(value: "osvaldo-pugliese", label: "Osvaldo Pugliese", count: 1)
      ]

      expect(facet.name).to eq("orchestra")
      expect(facet.options).to eq(expected_options)
    end
  end

  describe "#genres" do
    fit "returns a genre facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).genre
      expected_options = [
        Video::FacetBuilder::Option.new(value: "tango", label: "Tango", count: 4),
        Video::FacetBuilder::Option.new(value: "milonga", label: "Milonga", count: 1),
        Video::FacetBuilder::Option.new(value: "vals", label: "Vals", count: 1)
      ]

      expect(facet.name).to eq("genre")
      expect(facet.options).to eq(expected_options)
    end
  end

  describe "#years" do
    fit "returns a year facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).year
      expected_options = [
        Video::FacetBuilder::Option.new(value: 2020, label: 2020, count: 2),
        Video::FacetBuilder::Option.new(value: 2021, label: 2021, count: 1),
        Video::FacetBuilder::Option.new(value: 2018, label: 2018, count: 1),
        Video::FacetBuilder::Option.new(value: 2014, label: 2014, count: 1),
        Video::FacetBuilder::Option.new(value: 2013, label: 2013, count: 1)
      ]

      expect(facet.name).to eq("year")
      expect(facet.options).to eq(expected_options)
    end
  end

  describe "#songs" do
    fit "returns a song facet for all videos" do
      facet = Video::FacetBuilder.new(Video.all).song
      expected_options = [
        Video::FacetBuilder::Option.new(value: "nueve-de-julio-juan-darienzo", label: "Nueve De Julio - Juan D'Arienzo - Tango - 1935", count: 2),
        Video::FacetBuilder::Option.new(value: "cuando-el-amor-muere-carlos-di-sarli", label: "Cuando El Amor Muere - Carlos Di Sarli - Tango - 1941", count: 1),
        Video::FacetBuilder::Option.new(value: "malandraca-osvaldo-pugliese", label: "Malandraca - Osvaldo Pugliese - Tango - 1948", count: 1),
        Video::FacetBuilder::Option.new(value: "milonga-querida-juan-darienzo", label: "Milonga Querida - Juan D'Arienzo - Milonga - 1938", count: 1),
        Video::FacetBuilder::Option.new(value: "violetas-aberto-castillo", label: "Violetas - Alberto Castillo - Vals - 1948", count: 1)
      ]

      expect(facet.name).to eq("song")
      expect(facet.options).to eq(expected_options)
    end
  end
end
