# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails
  .application
  .reloader
  .to_prepare do
    # Autoload classes and modules needed at boot time here.
  end
