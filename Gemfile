source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
gem "solidus_auth_devise", github: "solidusio/solidus_auth_devise"

group :test, :development do
  gem "pry"
end

gemspec
