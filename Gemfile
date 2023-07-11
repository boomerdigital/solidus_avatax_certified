# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'main')

gem 'solidus', github: 'solidusio/solidus', branch: solidus_branch
gem 'solidus_auth_devise'
gem 'avatax-ruby', git: 'git@github.com:boomerdigital/avatax.git', require: 'avatax', branch: 'crossborder'

# The solidus_frontend gem has been pulled out since v3.2
if solidus_branch >= 'v3.2'
  gem 'solidus_frontend'
elsif solidus_branch == 'main'
  gem 'solidus_frontend', github: 'solidusio/solidus_frontend'
else
  gem 'solidus_frontend', github: 'solidusio/solidus', branch: solidus_branch
end

# Needed to help Bundler figure out how to resolve dependencies,
# otherwise it takes forever to resolve them.
# See https://github.com/bundler/bundler/issues/6677
gem 'rails', '>0.a'

case ENV['DB']
when 'postgresql'
  gem 'pg'
when 'mysql'
  gem 'mysql2'
else
  gem 'sqlite3'
end

gemspec
