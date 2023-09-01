# frozen_string_literal: true

class UserResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> { scope.search(params[:q]) }

  field :id, as: :id
  field :email,
    as: :gravatar,
    rounded: false,
    size: 60
  field :email, as: :text, link_to_resource: true
  field :name, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :uid, as: :text
  field :provider, as: :text
  field :confirmation_token, as: :text, hide_on: [:index]
  field :confirmed_at, as: :datetime, hide_on: [:index]
  field :confirmation_sent_at, as: :datetime
  field :unconfirmed_email, as: :text
  field :role, as: :select, enum: ::User.roles
  field :avatar, as: :file, is_image: true, as_avatar: :circle
  field :created_at, as: :datetime
end
