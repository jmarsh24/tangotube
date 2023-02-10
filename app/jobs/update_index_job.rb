# frozen_string_literal: true

class UpdateIndexJob < ApplicationJob
  queue_as :low_priority

  def perform(class_name, ids)
    query = class_name.constantize.index_query
    ApplicationRecord.connection.execute ApplicationRecord.send(:sanitize_sql_array, [query, ids])
  end
end
