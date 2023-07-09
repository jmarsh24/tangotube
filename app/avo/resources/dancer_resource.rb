# frozen_string_literal: true

class DancerResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.search(params[:q])
  end

  field :id, as: :id
  field :reviewed, as: :boolean
  field :profile_image, as: :file, is_image: true, is_avatar: true
  field :name, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :middle_name, as: :text
  field :nick_name, as: :tags
  field :videos_count, as: :number, sortable: true, read_only: true, only_on: [:index, :show]
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

  action ToggleReviewed
  action UpdateVideoMatches

  filter ReviewedFilter
end
