# frozen_string_literal: true

class ToggleActive < Avo::BaseAction
  self.name = "Toggle Active"

  def handle(**args)
    models, _fields = args.values_at(:models, :fields)

    models.each do |model|
      if model.active
        model.update active: false
      else
        model.update active: true
      end
    end

    succeed "Successfully toggled active!"
  end
end
