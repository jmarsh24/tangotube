# frozen_string_literal: true

# == Schema Information
#
# Table name: features
#
#  id               :uuid             not null, primary key
#  user_id          :bigint           not null
#  featureable_type :string           not null
#  featureable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Feature < ApplicationRecord
  belongs_to :user
  belongs_to :featureable, polymorphic: true
  counter_culture :featureable,
    column_name: proc { |model| (model.featureable_type == "Video") ? "features_count" : nil },
    column_names: {["features.featureable_type = ?", "Video"] => "features_count"}
end
