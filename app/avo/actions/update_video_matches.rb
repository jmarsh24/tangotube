# frozen_string_literal: true

class UpdateVideoMatches < Avo::BaseAction
  self.name = "Update Video Matches"

  def handle(**args)
    models, _fields = args.values_at(:models, :fields)

    models.each do |model|
      if model.respond_to?(:update_video_matches)
        model.update_video_matches
      end
    end

    succeed "Successfully created #{model.videos_count} videos for #{model.name}."
  end
end
