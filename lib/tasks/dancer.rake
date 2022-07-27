
namespace :dancer do
  task :create_dancer_from_leaders => :environment do
  Leader.all.each do |dancer|
    Dancer.create!(
      name: dancer.name,
      first_name: dancer.first_name,
      last_name: dancer.last_name,
      reviewed: dancer.reviewed || false,
      nick_name: dancer.nickname )
    end
  end

  task :create_dancer_from_followers => :environment do
    Follower.all.each do |dancer|
      Dancer.create!(
        name: dancer.name,
        first_name: dancer.first_name,
        last_name: dancer.last_name,
        reviewed: dancer.reviewed || false,
        nick_name: dancer.nickname )
    end
  end

  task :create_dancer_video_from_leaders => :environment do
    Video.has_leader.each do |video|
      DancerVideo.create(
        video: video,
        dancer: Dancer.find_by(name: video&.leader&.name),
        role: :leader
      )
    end
  end

  task :create_dancer_video_from_followers => :environment do
    Video.has_follower.each do |video|
      DancerVideo.create(
        video: video,
        dancer: Dancer.find_by(name: video&.follower&.name),
        role: :follower
      )
    end
  end

  task :create_couples_from_dancer_videos => :environment do
    videos_with_multiple_dancers_per_id = Video.joins(:dancers).group(:id).having('COUNT(videos.id) > 1').count

    videos_with_multiple_dancers_per_id = videos_with_multiple_dancers_per_id.keys

    DancerVideo.where(video_id: videos_with_multiple_dancers_per_id).group_by(&:video_id).each do |_video_id, dancer_videos|
      dancers_in_video = dancer_videos.map(&:dancer_id)
      dancer_a = Dancer.find(dancers_in_video[0])
      dancer_a.couples.create(partner_id: dancers_in_video[1])
    rescue ActiveRecord::RecordNotUnique
    end
  end

  task :create_slug_for_dancers_with_empty_or_nil_string => :environment do
    Dancer.where(slug: [nil, ""]).each do |dancer|
      dancer.slug = dancer.name.parameterize
      dancer.save
    end
  end
end
