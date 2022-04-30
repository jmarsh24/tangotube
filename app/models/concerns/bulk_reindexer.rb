require "sidekiq/api"

# BulkReindexer
module BulkReindexer
  def self.reindex_model(model, promote_and_clean = true)
    puts "Reindexing #{model.name}..."
    index = model.reindex(async: true, refresh_interval: "30s")
    puts "All jobs are in queue. Index name: #{index[:index_name]}"
    loop do
      # Check the size of queue
      queue_size = Sidekiq::Queue.new("searchkick").size
      puts "Jobs left: #{queue_size}"
      # Check every 5 seconds
      sleep 5
      break if queue_size.zero?
    end
    puts "Jobs complete. Promoting..."
    promote_and_clean(model, index) if promote_and_clean
  end

  def self.promote_and_clean(model, index)
    model.search_index.promote(index[:index_name],
                               update_refresh_interval: true)
    puts "Reindex of #{model.name} complete."
    puts "Cleaning old indices"
    model.search_index.clean_indices
  end
end
