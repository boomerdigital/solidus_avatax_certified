# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'solidus_dev_support/rspec/coverage'

# Create the dummy app if it's still missing.
dummy_env = "#{__dir__}/dummy/config/environment.rb"
system 'bin/rake extension:test_app' unless File.exist? dummy_env
require dummy_env

require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/controller_requests'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!

  config.example_status_persistence_file_path = "./spec/examples.txt"

  config.include Spree::TestingSupport::ControllerRequests, type: :controller
end
