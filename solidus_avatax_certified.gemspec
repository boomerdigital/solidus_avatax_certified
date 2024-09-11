# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_avatax_certified/version'

Gem::Specification.new do |s|
  s.name = 'solidus_avatax_certified'
  s.version = SolidusAvataxCertified::VERSION
  s.summary = 'Solidus extension for Avalara tax calculation.'
  s.description = 'Solidus extension for Avalara tax calculation.'
  s.authors = ['Allison Reilly', 'Nebulab', 'Framework Computer']
  s.email = ['acreilly3@gmail.com', 'hello@nebulab.com', 'support@frame.work']
  s.homepage = 'https://github.com/boomerdigital/solidus_avatax_certified'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'avatax-ruby'
  s.add_dependency 'deface', '>= 1.5'
  s.add_dependency 'json', '>= 2.0'
  s.add_dependency 'logging', '>= 2.0'
  s.add_dependency 'solidus_core', ['>= 3', '< 5']
  s.add_dependency 'solidus_support', [">= 0.8", "< 1"]

  s.add_development_dependency 'cuprite'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'solidus_dev_support', '>= 2.5'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
