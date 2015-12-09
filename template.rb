gem 'devise'
gem 'puma'
gem 'pg'
gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'rails_12factor'
gem 'twilio-ruby', '~> 4.1.0'

gem_group :development do
  # Used to find inefficient ActiveRecord queries.
  gem 'bullet'
  # Used to view mail messages in a web browser without actually sending a
  # message through a mail server.
  gem 'letter_opener'
end

gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'byebug'
  gem 'database_cleaner'
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'spring'
  gem 'sqlite3'
  gem 'web-console', '~> 2.0'
end

gem_group :test do
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'ci_reporter_minitest'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end