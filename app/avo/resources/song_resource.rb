# frozen_string_literal: true

class SongResource < Avo::BaseResource
  self.title = :full_title
  self.includes = [:orchestra, :videos]
  self.search_query = -> { scope.search(params[:q]) }
  self.resolve_query_scope = ->(model_class:) do
    model_class.most_popular
  end

  self.find_record_method = ->(model_class:, id:, params:) {
    (!id.is_a?(Array) && id.to_i == 0) ? model_class.find_by(slug: id) : model_class.find(id)
  }

  field :id, as: :id
  field :genre, as: :text
  field :title, as: :text
  field :orchestra, as: :belongs_to
  field :videos_count, as: :number do
    model.videos.length
  end
  field :artist, as: :text, hide_on: [:index]
  field :artist_2, as: :text, hide_on: [:index]
  field :composer, as: :text, hide_on: [:index]
  field :author, as: :text, hide_on: [:index]
  field :date, as: :date, hide_on: [:index]
  field :last_name_search, as: :text, hide_on: [:index]
  field :popularity, as: :number, hide_on: [:index]
  field :active, as: :boolean
  field :lyrics, as: :text, hide_on: [:index]
  field :el_recodo_song_id, as: :number, hide_on: [:index]
  field :videos_count, as: :number, read_only: true, sortable: true, hide_on: [:new, :edit]
  field :lyrics_en, as: :text, hide_on: [:index]
  field :slug, as: :text
  field :videos, as: :has_many
  # Assuming that you have defined the associations leaders and followers in the Song model
  field :leaders, as: :has_many, through: :videos
  field :followers, as: :has_many, through: :videos

  filter FeaturedFilter
  filter HiddenFilter
  filter ActiveFilter
end
