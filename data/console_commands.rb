
#Matches Song AND Artist with Video description

  Song.all.each do |song|
    Video.where( "unaccent(description) ILIKE unaccent(?) AND unaccent(description) ILIKE unaccent(?) ", "%#{song.title}%", "%#{song.artist.split.last}%").each do |video|
      if video.song.nil?
      video.song = song
      video.save
      end
    end
  end

  #Matches Event with Video description

  Event.all.each do |event|
    Video.where( "unaccent(description) ILIKE unaccent(?)", "%#{event.name}%").each do |video|
      video.event = event
      video.save
    end
    puts Video.pluck(:event_id).count
  end

    #Matches Event with Video title

   Event.all.each do |event|
    Video.where( "unaccent(title) ILIKE unaccent(?)", "%#{event.name}%").each do |video|
      video.event = event
      video.save
    end
    puts "#{Event.count} matches"
   end

    #Matches Videotype with Video title
    Videotype.all.each do |videotype|
      Video.where(videotype_id: nil).where( "unaccent(title) ILIKE unaccent(?)", "% #{videotype.name} %").each do |video|
        video.videotype = videotype
        video.save
      end
    end

    #Matches Videotype with Video description

    Videotype.all.each do |videotype|
      Video.where(videotype_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "% #{videotype.name} %").each do |video|
        video.videotype = videotype
        video.save
      end
    end



  #SQL match for Follower
  Follower.all.each do |follower|
    Video.all.where(follower_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "%#{follower.name}%").each do |video|
      video.follower = follower
      video.save
    end
    puts Video.pluck(:follower_id).count
  end

    #SQL match for Follower
    Follower.all.each do |follower|
      Video.all.where(follower_id: nil).where( "unaccent(tags) ILIKE unaccent(?)", "%#{follower.name}%").each do |video|
        video.follower = follower
        video.save
      end
    end

    #SQL match for Leader
    Leader.all.each do |leader|
      Video.all.where(leader_id: nil).where( "unaccent(tags) ILIKE unaccent(?)", "%#{leader.name}%").each do |video|
        video.leader = leader
        video.save
      end
    end
    

  Leader.all.each do |leader|
    Video.all.where(leader_id: nil).where( "unaccent(description) ILIKE unaccent(?)", "%#{leader.name}%").each do |video|
      video.leader = leader
      video.save
    end
  end

    #SQL match for Leader using fuzzystrmatch
    Leader.all.each do |leader|
      Video.where(leader_id: nil).where( "levenshtein(unaccent(title), unaccent(?) ) < 4 ", leader.name).each do |video|
        video.leader = leader
        video.save
      end
    end

        #SQL match for Leader using fuzzystrmatch
        Leader.all.each do |leader|
          Video.where(leader_id: nil).where( "levenshtein(unaccent(description), unaccent(?) ) < 4 ", leader.name).each do |video|
            video.leader = leader
            video.save
          end
        end

    Follower.all.each do |follower|
      Video.where(follower_id: nil).where( "levenshtein(unaccent(title), unaccent(?) ) < 4", follower.name).each do |video|
        video.follower = follower
        video.save
      end
    end

/* Performance Number */
regExp = /\([\d]{1}([\/]+[\d]{1})\)/
split_value = "/(-)(/)/"
Video.all.each do |video|
  parsed_title = video.title.match(/\([\d]{1}([\/]+[\d]{1})\)/)
  performance_number = parsed_title.split("/")
  video.performance_number = performance_number.first 
  video.performance_total  = performance_number.last
video.save
end

