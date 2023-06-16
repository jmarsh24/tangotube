# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Search do
  fixtures :all

  describe "#videos" do
    context "when not searching for anything" do
      it "returns all videos with facets" do
        leaders_facet =
          Video::FacetBuilder::Facet.new(name: "leader", options: [
            Video::FacetBuilder::Option.new(label: "Carlitos Espinoza (2)", value: "carlitos-espinoza"),
            Video::FacetBuilder::Option.new(label: "Corina Herrera (1)", value: "corina-herrera"),
            Video::FacetBuilder::Option.new(label: "Gianpiero Ya Galdi (1)", value: "gianpiero-ya-galdi"),
            Video::FacetBuilder::Option.new(label: "Jonathan Saavedra (1)", value: "jonathan-saavedra"),
            Video::FacetBuilder::Option.new(label: "Octavio Fernandez (1)", value: "octavio-fernandez")
          ])

        followers_facet =
          Video::FacetBuilder::Facet.new(name: "follower", options: [
            Video::FacetBuilder::Option.new(label: "Noelia Hurtado (2)", value: "noelia-hurtado"),
            Video::FacetBuilder::Option.new(label: "Clarisa Aragon (1)", value: "clarisa-aragon"),
            Video::FacetBuilder::Option.new(label: "Corina Herrera (1)", value: "corina-herrera"),
            Video::FacetBuilder::Option.new(label: "Inez Muzzopapa (1)", value: "inez-muzzopapa"),
            Video::FacetBuilder::Option.new(label: "Lorena Tarrantino (1)", value: "lorena-tarrantino")
          ])

        orchestras_facet =
          Video::FacetBuilder::Facet.new(name: "orchestra", options: [
            Video::FacetBuilder::Option.new(label: "Juan D'Arienzo (3)", value: "juan-darienzo"),
            Video::FacetBuilder::Option.new(label: "Alberto Castillo (1)", value: "alberto-castillo"),
            Video::FacetBuilder::Option.new(label: "Carlos Di Sarli (1)", value: "carlos-di-sarli"),
            Video::FacetBuilder::Option.new(label: "Osvaldo Pugliese (1)", value: "osvaldo-pugliese")
          ])

        genres_facet =
          Video::FacetBuilder::Facet.new(name: "genre", options: [
            Video::FacetBuilder::Option.new(label: "Tango (4)", value: "tango"),
            Video::FacetBuilder::Option.new(label: "Milonga (1)", value: "milonga"),
            Video::FacetBuilder::Option.new(label: "Vals (1)", value: "vals")
          ])

        years_facet =
          Video::FacetBuilder::Facet.new(name: "year", options: [
            Video::FacetBuilder::Option.new(label: "2020 (2)", value: 2020),
            Video::FacetBuilder::Option.new(label: "2021 (1)", value: 2021),
            Video::FacetBuilder::Option.new(label: "2018 (1)", value: 2018),
            Video::FacetBuilder::Option.new(label: "2014 (1)", value: 2014),
            Video::FacetBuilder::Option.new(label: "2013 (1)", value: 2013)
          ])

        songs_facet =
          Video::FacetBuilder::Facet.new(name: "song", options: [
            Video::FacetBuilder::Option.new(label: "Nueve De Julio (2)", value: "nueve-de-julio-juan-darienzo"),
            Video::FacetBuilder::Option.new(label: "Cuando El Amor Muere (1)", value: "cuando-el-amor-muere-carlos-di-sarli"),
            Video::FacetBuilder::Option.new(label: "Malandraca (1)", value: "malandraca-osvaldo-pugliese"),
            Video::FacetBuilder::Option.new(label: "Milonga Querida (1)", value: "milonga-querida-juan-darienzo"),
            Video::FacetBuilder::Option.new(label: "Violetas (1)", value: "violetas-aberto-castillo")
          ])

        expect(Video::Search.new.facet(name: "leaders")).to match_array(leaders_facet)
        expect(Video::Search.new.facet(name: "followers")).to match_array(followers_facet)
        expect(Video::Search.new.facet(name: "orchestras")).to match_array(orchestras_facet)
        expect(Video::Search.new.facet(name: "genres")).to match_array(genres_facet)
        expect(Video::Search.new.facet(name: "years")).to match_array(years_facet)
        expect(Video::Search.new.facet(name: "songs")).to match_array(songs_facet)
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
        expect(search.facet(name: "leaders")).to eq(leaders_facet)
        expect(search.facet(name: "followers")).to eq(followers_facet)
        expect(search.facet(name: "orchestras")).to eq(orchestras_facet)
        expect(search.facet(name: "genres")).to eq(genres_facet)
        expect(search.facet(name: "years")).to eq(years_facet)
        expect(search.facet(name: "songs")).to eq(songs_facet)
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

        expect(search.facet(name: "leaders")).to eq(leaders_facet)
        expect(search.facet(name: "followers")).to eq(followers_facet)
        expect(search.facet(name: "orchestras")).to eq(orchestras_facet)
        expect(search.facet(name: "genres")).to eq(genres_facet)
        expect(search.facet(name: "years")).to eq(years_facet)
        expect(search.facet(name: "songs")).to eq(songs_facet)
      end
    end
  end
end
