# frozen_string_literal: true

module ConsoleFriendlyLogger
  # Sets the logger to STD OUT. Also wraps the logger in a "severity formatter", which will prepent every
  # entry with an icon for its severity (see `LogSeverityFormatter`).
  #
  # Useful when:
  # - running Rails server within TMUX (ex: using `bin/dev`)
  # - executing a Rake command, to also display what's logged to Rails.
  #
  # Extends the Rails logger only if:
  # - we're in development and running through TMUX (ex: using `bin/dev`).
  # - RAILS_DEV_LOG_TO_STDOUT is truthy, which is useful when running Rails directly or executing a Rake task.
  #
  def self.auto_extend_rails!
    env_param = ENV["RAILS_DEV_LOG_TO_STDOUT"].presence&.downcase
    explicitly_disabled = ["0", "n", "f", "no", "false"].include?(env_param)
    return if explicitly_disabled

    explicitly_enabled = ["1", "y", "t", "yes", "true"].include?(env_param)
    in_dev_tmux_mode = Rails.env.development? && ENV["TMUX"].present?
    return unless explicitly_enabled || in_dev_tmux_mode

    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = LogSeverityFormatter.new(logger.formatter)
    new_logger = ActiveSupport::TaggedLogging.new(logger)
    Rails.logger.extend(ActiveSupport::Logger.broadcast(new_logger))
  end
end
