# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Search do
  fixtures :all

  describe "#videos" do
    it "returns all videos with facets" do
      expect(Video::Search.new.facet(name: "leader").options).to eq(Video::FacetBuilder.new(Video.all).leader.options)
      expect(Video::Search.new.facet(name: "follower").options).to eq(Video::FacetBuilder.new(Video.all).follower.options)
      expect(Video::Search.new.facet(name: "orchestra").options).to eq(Video::FacetBuilder.new(Video.all).orchestra.options)
      expect(Video::Search.new.facet(name: "genre").options).to eq(Video::FacetBuilder.new(Video.all).genre.options)
      expect(Video::Search.new.facet(name: "year").options).to eq(Video::FacetBuilder.new(Video.all).year.options)
      expect(Video::Search.new.facet(name: "song").options).to eq(Video::FacetBuilder.new(Video.all).song.options)
    end

    it "returns all videos when filtering with leader and sorting" do
      search = Video::Search.new(filtering_params: {leader: "corina-herrera"})
      expected_videos = Video::Filter.new(Video.all, filtering_params: {leader: "corina-herrera"}).filtered_videos

      expect(search.videos).to match_array(expected_videos)
      expect(search.facet(name: "leader").options).to eq(Video::FacetBuilder.new(Video.all).leader.options)
      expect(search.facet(name: "follower").options).to eq(Video::FacetBuilder.new(search.videos).follower.options)
      expect(search.facet(name: "orchestra").options).to eq(Video::FacetBuilder.new(search.videos).orchestra.options)
      expect(search.facet(name: "genre").options).to eq(Video::FacetBuilder.new(search.videos).genre.options)
      expect(search.facet(name: "year").options).to eq(Video::FacetBuilder.new(search.videos).year.options)
      expect(search.facet(name: "song").options).to eq(Video::FacetBuilder.new(search.videos).song.options)
    end

    it "returns all videos when filtering with leader and sorting" do
      leaders_facet =
        Video::FacetBuilder::Facet.new(name: "leader", options: [
          Video::FacetBuilder::Option.new(label: "Corina Herrera (1)", value: "corina-herrera")
        ])

      followers_facet =
        Video::FacetBuilder::Facet.new(name: "follower", options: [
          Video::FacetBuilder::Option.new(label: "Inez Muzzopapa (1)", value: "inez-muzzopapa")
        ])

      orchestras_facet =
        Video::FacetBuilder::Facet.new(name: "orchestra", options: [
          Video::FacetBuilder::Option.new(label: "Juan D'Arienzo (1)", value: "juan-darienzo")
        ])

      genres_facet =
        Video::FacetBuilder::Facet.new(name: "genre", options: [
          Video::FacetBuilder::Option.new(label: "Milonga (1)", value: "milonga")
        ])

      years_facet =
        Video::FacetBuilder::Facet.new(name: "year", options: [
          Video::FacetBuilder::Option.new(label: "2020 (1)", value: 2020)
        ])

      songs_facet =
        Video::FacetBuilder::Facet.new(name: "song", options: [
          Video::FacetBuilder::Option.new(label: "Milonga Querida (1)", value: "milonga-querida-juan-darienzo")
        ])

      search = Video::Search.new(filtering_params: {leader: "corina-herrera"})
      expected_videos = Video::Filter.new(Video.all, filtering_params: {leader: "corina-herrera"}).filtered_videos

      expect(search.videos).to match_array(expected_videos)
      expect(search.facet(name: "leader")).to eq(leaders_facet)
      expect(search.facet(name: "follower")).to eq(followers_facet)
      expect(search.facet(name: "orchestra")).to eq(orchestras_facet)
      expect(search.facet(name: "genre")).to eq(genres_facet)
      expect(search.facet(name: "year")).to eq(years_facet)
      expect(search.facet(name: "song")).to eq(songs_facet)
    end

    it "returns all videos when filtering with liked" do
      leaders_facet =
        Video::FacetBuilder::Facet.new(name: "leader", options: [
          Video::FacetBuilder::Option.new(label: "Carlitos Espinoza (1)", value: "carlitos-espinoza")
        ])

      followers_facet =
        Video::FacetBuilder::Facet.new(name: "follower", options: [
          Video::FacetBuilder::Option.new(label: "Noelia Hurtado (1)", value: "noelia-hurtado")
        ])

      orchestras_facet =
        Video::FacetBuilder::Facet.new(name: "orchestra", options: [
          Video::FacetBuilder::Option.new(label: "Carlos Di Sarli (1)", value: "carlos-di-sarli")
        ])

      genres_facet =
        Video::FacetBuilder::Facet.new(name: "genre", options: [
          Video::FacetBuilder::Option.new(label: "Tango (1)", value: "tango")
        ])

      years_facet =
        Video::FacetBuilder::Facet.new(name: "year", options: [
          Video::FacetBuilder::Option.new(label: "2014 (1)", value: 2014)
        ])

      songs_facet =
        Video::FacetBuilder::Facet.new(name: "song", options: [
          Video::FacetBuilder::Option.new(label: "Cuando El Amor Muere (1)", value: "cuando-el-amor-muere-carlos-di-sarli")
        ])

      user = users(:regular)
      video = videos(:video_1_featured)
      video.upvote_by user, vote_scope: "like"

      search = Video::Search.new(filtering_params: {liked: "true"}, user:)

      expect(search.videos).to match_array([videos(:video_1_featured)])

      expect(search.facet(name: "leader")).to eq(leaders_facet)
      expect(search.facet(name: "follower")).to eq(followers_facet)
      expect(search.facet(name: "orchestra")).to eq(orchestras_facet)
      expect(search.facet(name: "genre")).to eq(genres_facet)
      expect(search.facet(name: "year")).to eq(years_facet)
      expect(search.facet(name: "song")).to eq(songs_facet)
    end
  end
end
