# frozen_string_literal: true

class Search
  attr_reader :term

  def initialize(term:)
    @term = term
  end

  def results
    @results ||= [channels, events, songs, orchestras, users, videos].flat_map { |e| e.limit(10) }
  end

  private

  def channels
    Channel.searched(term)
  end

  def events
    Event.searched(term)
  end

  def songs
    Song.searched(term)
  end

  def orchestras
    Orchestra.searched(term)
  end

  def users
    User.searched(term)
  end

  def videos
    Video.searched(term)
  end
end
