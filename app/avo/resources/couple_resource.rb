# frozen_string_literal: true

class CoupleResource < Avo::BaseResource
  self.title = :dancer_names
  self.includes = [:dancer]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :dancer, as: :belongs_to
  field :partner, as: :belongs_to
  field :videos_count, read_only: true, sortable: true, hide_on: [:new, :edit]
  field :slug, as: :text
  field :unique_couple_id, as: :text, hide_on: [:index, :show]
  field :couple_videos, as: :has_many
  field :videos, as: :has_many, through: :couple_videos
end
