# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_avatax_certified/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_avatax_certified'
  s.version     = SolidusAvataxCertified::VERSION
  s.summary     = 'Solidus extension for Avalara tax calculation.'
  s.description = 'Solidus extension for Avalara tax calculation.'
  s.required_ruby_version = Gem::Requirement.new('> 2.5')

  s.author    = 'Allison Reilly'
  s.email     = 'acreilly3@gmail.com'
  s.homepage  = 'https://github.com/boomerdigital/solidus_avatax_certified'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/boomerdigital/solidus_avatax_certified'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'avatax-ruby'
  s.add_dependency 'deface', '~> 1.0'
  s.add_dependency 'json', '~> 2.0'
  s.add_dependency 'logging', '~> 2.0'
  s.add_dependency 'solidus_core', ['>= 2.3.0', '< 5']
  s.add_dependency 'solidus_support', [">= 0.8.0", "< 1"]

  s.add_development_dependency 'solidus_dev_support', '~> 2.1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'cuprite'
end
