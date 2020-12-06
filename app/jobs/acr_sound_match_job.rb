class AcrSoundMatchJob < ApplicationJob
  queue_as :default

  def perform(channel_id)
    youtube_id = Video.import_channel(channel_id)
    Video.clip_audio(youtube_id)
    Video.grep_dancers(youtube_id)
    Video.acr_sound_match(file_name)
    Video.parse_acr_response(ask_acr_output)
  end
end
