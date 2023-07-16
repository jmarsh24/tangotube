# frozen_string_literal: true

class AddTrigramIndexToEventLocationAndTitle < ActiveRecord::Migration[7.0]
  def change
    remove_index :events, :title
    add_index :events, :title, using: :gist, opclass: :gist_trgm_ops, name: "index_events_on_title_trigram"
    add_index :events, :city, using: :gist, opclass: :gist_trgm_ops, name: "index_events_on_city_trigram"
    add_index :events, :country, using: :gist, opclass: :gist_trgm_ops, name: "index_events_on_country_trigram"
  end
end
