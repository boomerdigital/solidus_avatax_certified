# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    match_requests_on: [:method],
    record: :none,
    allow_playback_repeats: true,
  }
  config.ignore_hosts 'chromedriver.storage.googleapis.com'
end
