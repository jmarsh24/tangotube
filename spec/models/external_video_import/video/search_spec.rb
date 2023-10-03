# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Search do
  fixtures :all

  describe "#videos" do
    before do
      VideoSearch.refresh
      VideoScore.refresh
    end

    it "returns all videos with facets" do
      expect(Video::Search.new.facet(name: "leader").options).to eq(Video::FacetBuilder.new(Video.all).leader.options)
      expect(Video::Search.new.facet(name: "follower").options).to eq(Video::FacetBuilder.new(Video.all).follower.options)
      expect(Video::Search.new.facet(name: "orchestra").options).to eq(Video::FacetBuilder.new(Video.all).orchestra.options)
      expect(Video::Search.new.facet(name: "genre").options).to eq(Video::FacetBuilder.new(Video.all).genre.options)
      expect(Video::Search.new.facet(name: "year").options).to eq(Video::FacetBuilder.new(Video.all).year.options)
      expect(Video::Search.new.facet(name: "song").options).to eq(Video::FacetBuilder.new(Video.all).song.options)
    end

    it "returns all videos when filtering with leader and sorting" do
      leaders_facet = [
        Video::FacetBuilder::Option.new(label: "Carlitos Espinoza", value: "carlitos-espinoza", count: 2),
        Video::FacetBuilder::Option.new(label: "Corina Herrera", value: "corina-herrera", count: 1),
        Video::FacetBuilder::Option.new(label: "Gianpiero Ya Galdi", value: "gianpiero-ya-galdi", count: 1),
        Video::FacetBuilder::Option.new(label: "Jonathan Saavedra", value: "jonathan-saavedra", count: 1),
        Video::FacetBuilder::Option.new(label: "Octavio Fernandez", value: "octavio-fernandez", count: 1)
      ]

      followers_facet = [Video::FacetBuilder::Option.new(label: "Ines Muzzopapa", value: "ines-muzzopapa", count: 1)]

      orchestras_facet = [Video::FacetBuilder::Option.new(label: "Juan D'Arienzo", value: "juan-darienzo", count: 1)]

      genres_facet = [Video::FacetBuilder::Option.new(label: "Milonga", value: "milonga", count: 1)]

      years_facet = [Video::FacetBuilder::Option.new(label: 2020, value: 2020, count: 1)]

      songs_facet = [Video::FacetBuilder::Option.new(label: "Milonga Querida - Juan D'Arienzo - Milonga - 1938", value: "milonga-querida-juan-darienzo", count: 1)]

      search = Video::Search.new(filtering_params: {leader: "corina-herrera"})
      expected_videos = Video::Filter.new(Video.all, filtering_params: {leader: "corina-herrera"}).videos

      expect(search.videos).to match_array(expected_videos)
      expect(search.facet(name: "leader").options).to match_array(leaders_facet)
      expect(search.facet(name: "follower").options).to match_array(followers_facet)
      expect(search.facet(name: "orchestra").options).to match_array(orchestras_facet)
      expect(search.facet(name: "genre").options).to match_array(genres_facet)
      expect(search.facet(name: "year").options).to match_array(years_facet)
      expect(search.facet(name: "song").options).to match_array(songs_facet)
    end

    it "returns all videos when filtering with liked" do
      leaders_facet = [Video::FacetBuilder::Option.new(label: "Carlitos Espinoza", value: "carlitos-espinoza", count: 1)]

      followers_facet = [Video::FacetBuilder::Option.new(label: "Noelia Hurtado", value: "noelia-hurtado", count: 1)]

      orchestras_facet = [Video::FacetBuilder::Option.new(label: "Carlos Di Sarli", value: "carlos-di-sarli", count: 1)]

      genres_facet = [Video::FacetBuilder::Option.new(label: "Tango", value: "tango", count: 1)]

      years_facet = [Video::FacetBuilder::Option.new(label: 2014, value: 2014, count: 1)]

      songs_facet = [Video::FacetBuilder::Option.new(label: "Cuando El Amor Muere - Carlos Di Sarli - Tango - 1941", value: "cuando-el-amor-muere-carlos-di-sarli", count: 1)]

      user = users(:regular)
      video = videos(:video_1_featured)
      like = video.likes.new(user:)
      like.save

      search = Video::Search.new(filtering_params: {liked: "true"}, user:)

      expect(search.videos).to match_array([videos(:video_1_featured)])

      expect(search.facet(name: "leader").options).to eq(leaders_facet)
      expect(search.facet(name: "follower").options).to eq(followers_facet)
      expect(search.facet(name: "orchestra").options).to eq(orchestras_facet)
      expect(search.facet(name: "genre").options).to eq(genres_facet)
      expect(search.facet(name: "year").options).to eq(years_facet)
      expect(search.facet(name: "song").options).to eq(songs_facet)
    end
  end
end
