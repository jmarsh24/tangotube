class MeilisearchEnqueueJob
  include Sidekiq::Job

def perform(klass, record_id, remove)
    if remove
      klass.constantize.index.delete_document(record_id)
    else
      klass.constantize.find(record_id).index!
    end
  end
end
