# frozen_string_literal: true

class ToggleFeatured < Avo::BaseAction
  self.name = "Toggle Featured"

  def handle(**args)
    models, _fields = args.values_at(:models, :fields)

    models.each do |model|
      if model.featured
        model.update featured: false
      else
        model.update featured: true
      end
    end

    succeed "Perfect!"
  end
end
