# frozen_string_literal: true

class MigrateFeaturedData < ActiveRecord::Migration[7.0]
  def up
    user = User.find_by(email: "jmarsh24@gmail.com")
    return unless user

    Video.where(featured: true).each do |video|
      Feature.create!(
        user:,
        featureable: video
      )
    end
    remove_column :videos, :featured, :boolean
  end
end
