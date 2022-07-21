namespace :couple do
  task :create_slugs_for_couples => :environment do
    Couple.all.find_each do |couple|
      couple.update(slug: couple.couple_names.parameterize)
    end
  end
end
