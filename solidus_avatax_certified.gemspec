# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_avatax_certified/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_avatax_certified'
  s.version     = SolidusAvataxCertified::VERSION
  s.summary     = 'Solidus extension for Avalara tax calculation.'
  s.description = 'Solidus extension for Avalara tax calculation.'
  s.required_ruby_version = '>= 2.1'

  s.author    = 'Allison Reilly'
  s.email     = 'acreilly3@gmail.com'
  s.homepage  = 'http://www.boomerdigital.net'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "solidus_core", [">= 2.3.0", "< 3.0.0"]
  s.add_dependency "json", "~> 1.8"
  s.add_dependency "avatax-ruby"
  s.add_dependency "logging", "~> 2.0"
  s.add_dependency "solidus_support"


  s.add_development_dependency "dotenv"
  s.add_development_dependency "rspec-rails", "~> 3.2"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sass-rails"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "factory_bot"
  s.add_development_dependency "selenium-webdriver", "~> 2.53.4"
  s.add_development_dependency "capybara", "~> 2.11"
  s.add_development_dependency "poltergeist", "~> 1.16"
  s.add_development_dependency "phantomjs", "~> 2.1.1"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency 'shoulda-matchers', '~> 2.7'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'ffaker'
end
