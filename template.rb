#
# Frontend Gems
#

installed_bootstrap = yes?('Install twitter-bootstrap-rails gem?')
if installed_bootstrap
  # Twitter Bootstrap
  gem 'twitter-bootstrap-rails'
  generate 'bootstrap:install less'
  # bootstrap-datepicker-rails | bootstrap styled jQuery date input
  gem 'bootstrap-datepicker-rails' if yes?('Install bootstrap datepicker?')
  # jquery-rails - JavaScript Library required by Bootstrap v4
  gem 'jquery-rails'
  # less-rails | Used to ease Bootstrap theme modifications
  gem 'less-rails'
  # therubyracer | Required to use Less
  gem 'therubyracer'
end
# font-awesome-rails | icons
gem 'font-awesome-rails' if yes?('Install font-awesome-rails icons?')
# kaminari | pagination
if yes?('Install kaminari gem for pagination?')
  gem 'kaminari'
  generate 'kaminari:views default' # Genrate the default views from Kaminari
end

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
generate 'devise:views' if installed_bootstrap

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

# honeybadger | exception reporting
gem 'honeybadger'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[jruby]

#
# Backend Optional Gems
#

# Interact with Amazon Web Services (S3, CloudFront, etc.)
gem 'aws-sdk' if yes?('Install aws-sdk gem?')
# Cocoon for implementing forms for associated models.
gem 'cocoon' if yes?('Install cocoon gem for associated model forms?')
# Delayed Job Queue
installed_delayed_job = yes?('Install basic delayed_job queue?')
if installed_delayed_job
  gem 'delayed_job_active_record'
end
# A simple ActiveRecord mixin to add conventions for flagging records as
# discarded.
gem 'discard' if yes?('Install discard gem for, "soft deletes"?')
# fuzzily | inexact search matching
gem 'fuzzily' if yes?('Install fuzzily gem for, "fuzzy searches"?')
# geocoder | retrieve latitude and longitude for locations
gem 'geocoder' if yes?('Install geocoder gem?')
# net-sftp| connect to SFTP server for file drops.
gem 'net-sftp' if yes?('Install SFTP capability?')
# paper_trail| track changes to your rails models
if yes?('Install paper_trail gem?')
  gem 'paper_trail'
  # Track changes to associations of your rails models
  gem 'paper_trail-association_tracking' if yes?('Allow association tracking?')
end
# paperclip | file uploads
if yes?('Install paperclip gem for uploading files?')
  gem 'paperclip'
  gem 'delayed_paperclip' if installed_delayed_job
end
# rack-rewrite | 301 redirects (useful for domain name changes)
gem 'rack-rewrite' if yes?('Install rack-rewrite gem?')
# ransack - search models for specific records
gem 'ransack' if yes?('Install ransack (search) gem?')
# rubyXL - Read XLSX files, for importation of data from Excel. We're only going
# =>       to include this when we need it, during data importation.
gem 'rubyXL', require: false if yes?('Install rubyXL (.xlsx) gem?')
# For exporting binary Excel XLS format documents. Not to be confused with the
# Open XLSX standard.
gem 'spreadsheet', require: false if yes?('Install spreadsheet (.xls) gem?')
# twilio-ruby| sms and telephone communication
gem 'twilio-ruby' if yes?('Install twilio-ruby gem for sms and telephone?')

#
# API Specific Gems
#
# Oj, a faster library for exporting JSON.
if yes?('Install oj gem for faster JSON serialization?')
  gem 'oj'
  gem 'oj_mimic_json'
end
# Ox, a faster library for exporting XML.
gem 'ox' if yes?('Install ox gem for faster XML?')

# Heroku
gem_group :production do
  gem 'rails_12factor'
  gem 'pg'
end

#
# Development Only
#
gem_group :development do
  # benchmark-memory | a tool that helps you to benchmark memory usage
  gem 'benchmark-memory'
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
  gem 'sqlite3', '< 1.4.0'
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
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'ci_reporter_minitest'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

# Run
rake 'db:migrate db:seed'
