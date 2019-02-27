# Run Coverage report
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/dummy'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Views', 'app/views'
  add_group 'Libraries', 'lib'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'dotenv'
Dotenv.load

require 'rspec/rails'
require 'webmock/rspec'

require 'solidus_support/extension/rails_helper'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/order_walkthrough'
require "solidus_support/extension/feature_helper"

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'


Dir[File.join(File.dirname(__FILE__), 'factories/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.color = true
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = "random"

  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  Capybara.register_driver(:poltergeist) do |app|
    Capybara::Poltergeist::Driver.new app, timeout: 90
  end
  Capybara.javascript_driver = :poltergeist
  Capybara.server = :webrick
  Capybara.default_max_wait_time = 10

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    MyConfigPreferences.set_preferences
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      reset_spree_preferences
      MyConfigPreferences.set_preferences

      example.run
    end
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.before(:each, type: :feature, js: true) do |ex|
    Capybara.current_driver = ex.metadata[:driver] || :poltergeist
  end
end
