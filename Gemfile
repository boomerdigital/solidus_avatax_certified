source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'v2.0')
gem "solidus", github: "solidusio/solidus", branch: branch
gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"
gem 'avatax-ruby'

group :test, :development do
  gem "pry"
end

if branch == 'master' || branch >= "v2.0"
  gem "rails-controller-testing", group: :test
else
  gem "rails_test_params_backport", group: :test
end

gem 'pg', '~> 0.21'
gem 'mysql2'

gemspec
