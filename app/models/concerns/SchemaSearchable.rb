module SchemaSearchable
  extend ActiveSupport::Concern
  included do
    include MeiliSearch::Rails
    extend Pagy::Meilisearch
  end
  module ClassMethods
    def trigger_sidekiq_job(record, remove)
      MeilisearchEnqueueJob.perform_async(record.class.name, record.id, remove)
    end
  end
end
