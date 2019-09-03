# frozen_string_literal: true

source "https://rubygems.org"

solidus_branch = ENV.fetch("SOLIDUS_BRANCH", "master")

gem 'avatax-ruby'

gem "solidus", github: "solidusio/solidus", branch: solidus_branch
gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"

group :test do
  if solidus_branch != 'master' && solidus_branch < 'v2.0'
    gem "rails_test_params_backport"
  end
  if solidus_branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

gem "rails-controller-testing", group: :test

gem 'mysql2', '~> 0.4.10'
gem 'pg', '~> 0.21'

gemspec
