# frozen_string_literal: true

source 'https://rubygems.org'

solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'master')

gem 'solidus', github: 'solidusio/solidus', branch: solidus_branch
gem 'solidus_auth_devise'

case ENV['DB']
when 'postgresql'
  gem 'pg'
when 'mysql'
  gem 'mysql2'
else
  gem 'sqlite3'
end

gemspec
