# frozen_string_literal: true

class CoupleResource < Avo::BaseResource
  self.title = :dancer_names
  self.includes = [:dancer, :partner, :videos]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :dancer, as: :belongs_to
  field :dancer_image, as: :file, is_image: true, is_avatar: true do
    model.dancer.profile_image
  end
  field :partner, as: :belongs_to
  field :partner_image, as: :file, is_image: true, is_avatar: true, format_using: ->(model) { model.partner.profile_image }
  field :videos_count, as: :number do
    model.videos.length
  end
  field :slug, as: :text
  field :unique_couple_id, as: :text, hide_on: [:index, :show]
  field :couple_videos, as: :has_many
  field :videos, as: :has_many, through: :couple_videos
end
