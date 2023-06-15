# frozen_string_literal: true

class ToggleHidden < Avo::BaseAction
  self.name = "Toggle Hidden"

  def handle(**args)
    models, _fields = args.values_at(:models, :fields)

    models.each do |model|
      if model.hidden
        model.update hidden: false
      else
        model.update hidden: true
      end
    end

    succeed "Perfect!"
  end
end
