class Video::Display
  def initialize(video)
    @video = video
  end

  def display
    @display ||= Video::Display.new(self)
  end

  def any_song_attributes
    el_recodo_attributes || spotify_attributes || youtube_attributes ||
      acr_cloud_attributes
  end

  def external_song_attributes
    spotify_attributes || youtube_attributes || acr_cloud_attributes
  end

  def el_recodo_attributes
    return if @video.song.blank?

    "#{@video.song.title.titleize} - #{titleize_artist_name(@video.song.artist)} - #{@video.song.genre.titleize}"
  end

  def spotify_attributes
    if @video.spotify_track_name.blank? || @video.spotify_artist_name.blank?
      return
    end

    "#{@video.spotify_track_name.titleize} - #{titleize_artist_name(@video.spotify_artist_name)}"
  end

  def youtube_attributes
    return if @video.youtube_song.blank? || @video.youtube_artist.blank?

    "#{@video.youtube_song.titleize} - #{titleize_artist_name(@video.youtube_artist)}"
  end

  def acr_cloud_attributes
    if @video.acr_cloud_track_name.blank? || @video.acr_cloud_artist_name.blank?
      return
    end

    "#{@video.acr_cloud_track_name.titleize} - #{titleize_artist_name(@video.acr_cloud_artist_name)}"
  end

  def dancer_names
    return if @video.leader.blank? || @video.follower.blank?

    "#{@video.leader.name.titleize} & #{@video.follower.name.titleize}"
  end

  private

  def titleize_artist_name(artist_name)
    artist_name.split("'").map(&:titleize).join("'")
  end
end
