class SongResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :genre, as: :text
  field :title, as: :text
  field :artist, as: :text
  field :artist_2, as: :text
  # field :composer, as: :text
  # field :author, as: :text
  # field :date, as: :date
  # field :last_name_search, as: :text
  field :occur_count, as: :number
  # field :popularity, as: :number
  field :active, as: :boolean
  field :lyrics, as: :textarea
  # field :el_recodo_song_id, as: :number
  # field :videos_count, as: :number
  field :lyrics_en, as: :text
  # field :slug, as: :text
  # field :orchestra_id, as: :number
  # field :pg_search_document, as: :has_one
  field :orchestra, as: :belongs_to
  field :videos, as: :has_many
  # field :leaders, as: :has_many, through: :videos
  # field :followers, as: :has_many, through: :videos
  # add fields here
end
