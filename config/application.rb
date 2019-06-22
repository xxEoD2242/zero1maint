# frozen_string_literal: true

require_relative 'boot'
require File.expand_path('boot', __dir__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'csv'
require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zero1Maint
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1 
    config.autoload_paths += %W(#{config.root}/app/uploaders)
    # Don't generate system test files.
    config.generators.system_tests = nil
    config.assets.enabled = true
  end
end
