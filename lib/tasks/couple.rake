namespace :couple do
  task :create_slugs_for_couples => :environment do
    Couple.all.find_each do |couple|
      couple.update(slug: couple.couple_names.parameterize)
    end
  end

  task :create_couples => :environment do
    Couple.select(:unique_couple_id).group(:unique_couple_id).having("count(*) > 1").map(&:unique_couple_id).each do |unique_couple_id|
      couple = Couple.find_by(unique_couple_id:)
      dancer_id = couple.dancer_id
      partner_id = couple.partner_id
      DancerVideo.where(dancer_id: [dancer_id, partner_id])
      .group(:video_id)
      .having("count(*) = ?", [dancer_id, partner_id].count)
      .select(:video_id)
      .map { |id, video_id| id.video_id }.each do |video_id|
        CoupleVideo.create(video_id: video_id, couple_id: couple.id)
      end
    end
  end
end
