# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

AppConfig = Rails.application.config_for(:application)