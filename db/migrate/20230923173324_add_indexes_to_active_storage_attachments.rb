# frozen_string_literal: true

class AddIndexesToActiveStorageAttachments < ActiveRecord::Migration[7.0]
  def change
    add_index :active_storage_attachments, [:record_type, :name, :record_id], name: "index_on_record_type_name_and_id"
    add_index :active_storage_attachments, :record_id, name: "index_on_record_id"
  end
end
