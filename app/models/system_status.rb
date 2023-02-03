# frozen_string_literal: true

class SystemStatus
  def component_status
    @component_status ||= begin
      status = [:postgres, :sidekiq].index_with { |e| status_for(e) }
      status.merge(all: all_ok?(status) ? "ok" : "not ok")
    end
  end

  def all_ok?(status = component_status)
    status.values.uniq == ["ok"]
  end

  def postgres?
    ActiveRecord::Migrator.current_version
  end

  def sidekiq?
    raise StandardError, "High worker latency" if Sidekiq::Queue.new("dispatch").latency.seconds > 1.minute
  end

  private

  attr_reader :waiting_queue

  def status_for(component)
    public_send "#{component}?"
    "ok"
  rescue => e
    e.message
  end
end
