# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require 'solidus_dev_support/rspec/coverage'

require File.expand_path('dummy/config/environment.rb', __dir__)

require "webdrivers"

require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/controller_requests'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

require 'solidus_avatax_certified/testing_support/factories'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!

  config.example_status_persistence_file_path = "./spec/examples.txt"

  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end
end
