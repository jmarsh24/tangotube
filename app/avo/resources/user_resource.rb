class UserResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :email,
    as: :gravatar,
    rounded: false,
    size: 60,
    default_url: 'some image url'
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
  field :avatar, as: :file
  # field :pay_customers, as: :has_many
  # field :charges, as: :has_many, through: :pay_customers
  # field :subscriptions, as: :has_many, through: :pay_customers
  # field :payment_processor, as: :has_one
  field :votes, as: :has_many
  field :comments, as: :has_many
end
