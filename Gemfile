source "https://rubygems.org"

branch = 'master'
gem "solidus", github: "solidusio/solidus", branch: branch
gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"
gem 'avatax-ruby'

group :development do
  gem "pry"
end

if ENV['DB'] == 'mysql'
  gem 'mysql2'
else
  gem 'pg', '~> 0.21'
end

group :test do
  gem 'pry'
  gem 'rails-controller-testing'
  if branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

gemspec
