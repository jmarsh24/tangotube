# frozen_string_literal: true

class ToggleReviewed < Avo::BaseAction
  self.name = "Toggle Reviewed"

  def handle(**args)
    models, _fields = args.values_at(:models, :fields)

    models.each do |model|
      if model.reviewed
        model.update reviewed: false
      else
        model.update reviewed: true
      end
    end

    succeed "Perfect!"
  end
end
