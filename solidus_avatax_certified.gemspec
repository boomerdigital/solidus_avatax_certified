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
  s.required_ruby_version = '>= 2.1'

  s.author    = 'Allison Reilly'
  s.email     = 'acreilly3@gmail.com'
  s.homepage  = 'http://www.boomerdigital.net'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  solidus_version = ['>= 2.3.0', '< 3.0.0']
  s.add_dependency 'avatax-ruby'
  s.add_dependency 'deface', '~> 1.5'
  s.add_dependency 'json', '~> 2.0'
  s.add_dependency 'logging', '~> 2.0'
  s.add_dependency 'solidus', solidus_version
  s.add_dependency 'solidus_support', '~> 0.4.0'

  s.add_development_dependency 'solidus_dev_support'
  s.add_development_dependency 'vcr'
  # s.add_development_dependency 'webmock'
  s.add_development_dependency 'shoulda-matchers'
end
