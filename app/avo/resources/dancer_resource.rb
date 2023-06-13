# frozen_string_literal: true

class DancerResource < Avo::BaseResource
  self.title = :name
  self.includes = [:videos, :couples, :partners, :orchestras, :songs]
  self.search_query = -> do
    scope.ransack(name_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :reviewed, as: :boolean
  field :profile_image, as: :file, is_image: true, is_avatar: true
  field :name, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :middle_name, as: :text
  field :nick_name, as: :text
  field :videos_count, as: :number do
    model.videos.length
  end
  field :bio, as: :textarea, only_on: [:edit, :new, :show]
  field :slug, as: :text
  field :gender, as: :select, enum: ::Dancer.genders
  field :cover_image, as: :file, is_image: true, hide_on: [:index]
  field :user, as: :belongs_to, hide_on: [:index, :show]
  field :dancer_videos, as: :has_many
  field :videos, as: :has_many, through: :dancer_videos
  field :orchestras, as: :has_many, through: :videos
  field :songs, as: :has_many, through: :videos
  field :couples, as: :has_many
  field :partners, as: :has_many, through: :couples
end
