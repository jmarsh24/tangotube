# frozen_string_literal: true

class UserResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :email,
    as: :gravatar,
    rounded: false,
    size: 60
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
  field :avatar, as: :file, is_image: true, is_avatar: true
  field :comments, as: :has_many

  # def scopes
  #   scope Avo::Scopes::Admins
  #   scope Avo::Scopes::NonAdmins
  # end
end
