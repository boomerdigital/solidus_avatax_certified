source "https://rubygems.org"

branch = 'master'
gem "solidus", github: "solidusio/solidus", branch: branch
gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"
gem 'avatax-ruby'

group :test, :development do
  gem "pry"
end

if branch < 'v2.5'
  gem 'factory_bot', '4.10.0'
else
  gem 'factory_bot', '> 4.10.0'
end

gem "rails-controller-testing", group: :test

gem 'pg', '~> 0.21'
gem 'mysql2'

gemspec
