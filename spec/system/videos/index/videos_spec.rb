# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Videos::Index::Videos" do
  it "reformats title with leader & follower" do
    setup_video
    updates_video_title_when_song_leader_follower_present
    updates_video_title_when_song_nil
    updates_video_title_when_leader_nil
    updates_video_title_when_follower_nil
  end

  def setup_video
    stub_const("Ahoy::Event::MIN_NUMBER_OF_VIEWS", 1)
    @leader = create(:leader, name: "Carlitos Espinoza")
    @follower = create(:follower, name: "Noelia Hurtado")
    @song = create(:song, title: "song_title")
    @event = create(:event, title: "event_title")
    @video =
      create(
        :watched_video,
        :display,
        title: "video_a",
        leader: @leader,
        follower: @follower,
        song: @song,
        event: @event
      )
  end

  def updates_video_title_when_song_leader_follower_present
    visit videos_path

    expect(video_title).to eq("Carlitos Espinoza & Noelia Hurtado")
  end

  def updates_video_title_when_song_nil
    @video.update(song: nil)
    visit videos_path
    expect(video_title).to eq("video_a")
    @video.update(song: @song)
  end

  def updates_video_title_when_leader_nil
    @video.update(leader: nil)
    visit videos_path
    expect(video_title).to eq("video_a")
    @video.update(leader: @leader)
  end

  def updates_video_title_when_follower_nil
    @video.update(follower: nil)
    visit videos_path
    expect(video_title).to eq("video_a")
    @video.update(follower: @follower)
  end

  def video_title
    page.find("div.video-title").text
  end
end
