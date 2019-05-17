#
# Core Gems
#

#
# Authentication
#
gem 'devise'
generate 'devise:install'
model_name = ask('What would you like the user model to be called? [User]')
model_name = 'User' if model_name.blank?
generate 'devise', model_name
generate 'devise:views' if yes?('Install Devise view files?')

#
# Access Control
#
gem 'pundit'
generate 'pundit:install'

#
# Require SSL in Production
#
gsub_file(
  'config/environments/production.rb', %r{# config\.force_ssl = true},
  "config.force_ssl = true"
)

#
# Seed an Administrative User
#
require 'securerandom'
# Remove stock file
remove_file 'db/seeds.rb'
# Create a new seeds file containing a user with a random password.
create_file 'db/seeds.rb', "User.create!(
  email: 'webmaster@cts-llc.net', password: '#{SecureRandom.hex}'
)\n"

#
# Setup Static Home Page
#
generate 'controller', 'static home'
route "root to: 'static#home'"
gsub_file('config/routes.rb', %r{^  get 'static\/home'\n$}, '')

# A simple ActiveRecord mixin to add conventions for flagging records as
# discarded.
gem 'discard'
# jQuery - JavaScript Library required by Bootstrap v4
gem 'jquery-rails'
# Pagination
gem 'kaminari'
# Genrate the default views from Kaminari
generate 'kaminari:views default'
# File Uploads
gem 'paperclip'
# Twilio for SMS and Telephone Communication
gem 'twilio-ruby'
# Twitter Bootstrap
gem 'twitter-bootstrap-rails'
generate 'bootstrap:install static'

# Heroku
gem_group :production do
  gem 'rails_12factor'
  gem 'pg'
end

#
# Development Only
#
gem_group :development do
  # Used to view mail messages in a web browser without actually sending a
  # message through a mail server.
  gem 'letter_opener'
  # rails-erd | generate entity relationship diagrams
  gem 'rails-erd'
end

#
# Development and Test
#
gem_group :development, :test do
  # brakeman | security scanner
  gem 'brakeman', require: false
  # https://github.com/flyerhzm/bullet
  #
  # The Bullet gem is designed to help you increase your application's
  # performance by reducing the number of queries it makes.
  gem 'bullet'
  application(nil, env: 'development') do
    %(# Enable Bullet, turn on /log/bullet.log, add notifications to footer.
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.add_footer    = true
    # Bullet.alert       = true
    # Bullet.console     = true
    # Bullet.growl       = true
    # Bullet.xmpp        = { :account  => 'bullets_account@jabber.org',
    #                        :password => 'bullets_password_for_jabber',
    #                        :receiver => 'your_account@jabber.org',
    #                        :show_online_status => true }
    # Bullet.rails_logger = true
    # Bullet.honeybadger  = true
    # Bullet.bugsnag      = true
    # Bullet.airbrake     = true
    # Bullet.rollbar      = true
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
    # Bullet.slack = { webhook_url: 'http://some.slack.url', foo: 'bar' }
  end)
  end
  application(nil, env: 'test') do
    %(# Enable Bullet, turn on /log/bullet.log during testing.
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
  end)
  end
  gem 'byebug', platforms: %i[mri]
  gem 'database_cleaner'
  # Use .env files to automatically load environment variables in development
  # and testing environments
  gem 'dotenv-rails'
  # i18n-tasks | manage internationalization and localization files
  gem 'i18n-tasks'
  # rack-mini-profiler | profile page loading
  gem 'rack-mini-profiler', require: false
  # rubocop | static code analysis
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-performance'
  gem 'spring'
  # Remove SQLite from ALL environments. Only want it in development and test.
  gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\n/, ''
  gsub_file 'Gemfile', /^gem 'sqlite3'\n/, ''
  # Add SQLite to development and test.
  gem 'sqlite3'
end

# Rubocop Configuration File
create_file 'config/rubocop.yml', "AllCops:
  Exclude:
    - 'db/**/*'
    - 'bin/*'
  TargetRubyVersion: 2.3\n"

# Alter Rakefile to include ci_reporter_minitest
gsub_file('Rakefile', "require_relative 'config/application'\n",
          "require_relative 'config/application'
if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
  require 'ci/reporter/rake/minitest'
end")

# Prepend SimpleCov to test_helper
prepend_file('test/test_helper.rb', "# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'\n")

# Append coverage report directory to .gitignore
append_file('.gitignore', "\n# Ignore Test Coverage Report Directory
/coverage/\n")
# Ignore .env files as they may contain sensitive information
append_file('.gitignore', "\n# Ignore development and test environment files
.env\n")

#
# Test Only -
#
gem_group :test do
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'ci_reporter_minitest'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

# Run
rake 'db:migrate db:seed'
