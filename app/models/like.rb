# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id            :uuid             not null, primary key
#  user_id       :bigint           not null
#  likeable_type :string           not null
#  likeable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
