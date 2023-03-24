module ExternalVideoImporter
  include Trigram

  class Video
    def call(video_metadata)
      channel = Channel.new.call(video_metadata)
      video = ::Video.find_or_initialize_by(
        youtube_id: video_metadata.youtube.slug
      )
      video.update!(
        channel:,
        description: video_metadata.youtube.description,
        duration: video_metadata.youtube.duration,
        title: video_metadata.youtube.title,
        view_count: video_metadata.youtube.view_count,
        tags: video_metadata.youtube.tags,
        like_count: video_metadata.youtube.like_count,
        favorite_count: video_metadata.youtube.favorite_count,
        comment_count: video_metadata.youtube.comment_count
      )
      video
    end
  end

  class Channel
    def call(video_metadata)
      channel = ::Channel.find_or_initialize_by(
        channel_id: video_metadata.youtube.channel.id
      )
      channel.update!(title: video_metadata.youtube.channel.title)
      channel
    end
  end

  # song = Song.new.call(video_metadata, q, self)
  # event = Event.new.call(video_metadata, q, self)
  # performance = Performance.new.call(video_metadata, q, self)
  # dancer = Dancer.new.call(video_metadata, q, self)
  # couple = Couple.new.call(video_metadata, q, self)
  # channel = Channel.new.call(video_metadata, q, self)
  # class Song
  #   def call(video_metadata, q, video)
  # q = Struct.new(ActiveRecord_primary_key, song_title, song_artist).each do |active_record_object_row|
  # query 1 = video_metadata[:song_information].trigrams
  # query 2 = q.uery(each song ActiveRecord, song_title, song_artist).trigrams
  #   end
  # end

  # if song = q.search(type: :song, video_metadata)
  #   q.insert!(type: :song, video_metadata)
  # else
  #   video.make_relation_to_song(id: song.id )
  # end

  # class Event

  # end

  # class Performance
  # end

  # class Dancer

  # end

  # class Couple

  # end

  # class Channel

  # end
end
