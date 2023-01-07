class DancerResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :name, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :middle_name, as: :text
  field :nick_name, as: :text
  field :user_id, as: :number
  field :bio, as: :textarea
  field :slug, as: :text
  field :reviewed, as: :boolean
  field :videos_count, as: :number
  field :gender, as: :select, enum: ::Dancer.genders
  field :profile_image, as: :file, image: true
  field :cover_image, as: :file, image: true
  field :user, as: :belongs_to
  field :dancer_videos, as: :has_many
  field :videos, as: :has_many, through: :dancer_videos
  field :orchestras, as: :has_many, through: :videos
  field :songs, as: :has_many, through: :videos
  field :couples, as: :has_many
  field :partners, as: :has_many, through: :couples
end
