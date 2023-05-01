namespace :video do
  namespace :update do
    desc "Enqueue update jobs in batches of 10,000"
    task :enqueue_batches, [:start_id] => :environment do |task, args|
      start_id = args[:start_id].to_i || 0
      batch_size = 10_000

      Video.where("id > ?", start_id).limit(batch_size).each do |video|
        UpdateVideoJob.perform_later(video)
      end
    end
  end
end
