module ExternalVideoImporter
  class Video
    def call(video_metadata)
      channel = Channel.new.call video_metadata
      video = ::Video.find_or_initialize_by(
        youtube_id: video_metadata.youtube.slug
      )
      song = Song.new.call video_metadata
      event = Event.new.call video_metadata
      dancers = Dancer.new.call video_metadata
      couples = Couple.new.call video_metadata

      video.update!(
        channel:,
        song:,
        event:,
        dancers:,
        couples:,
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
      channel = ::Channel.find_or_initialize_by channel_id: video_metadata.youtube.channel.id
      channel.update! title: video_metadata.youtube.channel.title
      channel
    end
  end

  class Song
    def call(video_metadata)
      possible_song_matches = []
      ::Song.all.pluck(:id, :title, :last_name_search).each do |song|
        song_trigram_match_value = Trigram.word_similarity "#{song[1]} #{song[2]}".parameterize(separator: " "), video_metadata.song_attributes.parameterize(separator: " ")
        if song_trigram_match_value > 0.3
          possible_song_matches << [song[0], song_trigram_match_value]
        end
      end
      possible_song_matches = possible_song_matches.sort_by { |match| match[1] }.reverse
      ::Song.find(possible_song_matches.first[0]) if possible_song_matches.first
    end
  end

  class Event
    def call(video_metadata)
      possible_event_matches = []
      ::Event.all.pluck(:id, :title).each do |event|
        event_trigram_match_value = Trigram.word_similarity event[1].parameterize(separator: " "), "#{video_metadata.youtube.title} #{video_metadata.youtube.description}".parameterize(separator: " ")
        if event_trigram_match_value > 0.3
          possible_event_matches << [event[0], event_trigram_match_value]
        end
      end
      possible_event_matches = possible_event_matches.sort_by { |match| match[1] }.reverse
      ::Event.find(possible_event_matches.first[0]) if possible_event_matches.first
    end
  end

  class Dancer
    def call(video_metadata)
      possible_dancer_matches = []
      ::Dancer.all.pluck(:id, :first_name, :last_name).each do |dancer|
        dancer_trigram_match_value = Trigram.word_similarity "#{dancer[1]} #{dancer[2]}".parameterize(separator: " "), video_metadata.youtube.title.parameterize(separator: " ")
        if dancer_trigram_match_value > 0.3
          possible_dancer_matches << [dancer[0], dancer_trigram_match_value]
        end
      end
      possible_dancer_matches = possible_dancer_matches.sort_by { |match| match[1] }.reverse
      ::Dancer.find(possible_dancer_matches.map(&:first)) if possible_dancer_matches.first
    end
  end

  class Couple
    def call(video_metadata)
      possible_couple_matches = []
      ::Couple.all.map { |couple| [couple.id, couple.dancer_names] }.each do |couple|
        couple_trigram_match_value = Trigram.word_similarity couple[1], video_metadata.youtube.title
        if couple_trigram_match_value > 0.3
          possible_couple_matches << [couple[0], couple_trigram_match_value]
        end
      end
      possible_couple_matches = possible_couple_matches.sort_by { |match| match[1] }.reverse
      ::Couple.find(possible_couple_matches.map(&:first)) if possible_couple_matches.first
    end
  end
end
