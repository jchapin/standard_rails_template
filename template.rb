# frozen_string_literal: true

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
  generate 'bootstrap:layout', 'application'
  # Add CSS that prevents body content from rendering underneath the navbar and
  # footer. Add CSS that renders the alerts in bootstrap alert dialogues.
  gsub_file(
    'app/assets/stylesheets/application.css',
    %r{^ \*\/\n}, " */\n\nbody {\n  margin: 50px 0 60px 0;\n}\n"
  )
  # Add jQuery and Bootstrap JS to the JavaScript manifest
  gsub_file(
    'app/assets/javascripts/application.js',
    %r{^//= require rails-ujs}, "//= require jquery3\n//= require rails-ujs"
  )
  gsub_file('app/assets/javascripts/application.js',
            %r{^//= require rails-ujs\n}, "//= require rails-ujs\n//= "\
            "require twitter/bootstrap\n")
end
# font-awesome-rails | icons
if yes?('Install font-awesome-rails icons?')
  gem 'font-awesome-rails'
  gsub_file(
    'app/assets/stylesheets/application.css',
    /^ \*= require_tree \./, " *= require_tree .\n *= require font-awesome"
  )
end
# kaminari | pagination
if yes?('Install kaminari gem for pagination?')
  gem 'kaminari'
  generate 'kaminari:views default' # Genrate the default views from Kaminari
end

#
# Core Gems
#

#
# Access Control
#
gem 'pundit'
generate 'pundit:install'
gsub_file(
  'app/controllers/application_controller.rb',
  /^end\n/, %(  include Pundit
  protect_from_forgery with: :exception
  # Require a User to be logged in for every action by default.
  before_action :authenticate_user!
  # Rescue from unauthorized with an error.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  ##
  # Forward the unauthorized user to the previous page or the home page of the
  # application.
  #
  def user_not_authorized
    flash[:alert] = t(:error_not_authorized)
    redirect_to(request.referer || root_path)
  end
end
)
)

#
# Authentication
#
gem 'devise'
generate 'devise:install'
model_name = ask('What would you like the user model to be called? [User]')
model_name = 'User' if model_name.blank?
generate 'devise', model_name
generate 'controller', model_name.pluralize
gsub_file(
  'config/routes.rb',
  /devise_for :users/, "devise_for :users\n  resources :users"
)
generate 'devise:views' if installed_bootstrap
generate 'bootstrap:themed', model_name.pluralize if installed_bootstrap
generate 'pundit:policy', model_name.pluralize

#
# Require SSL in Production
#
gsub_file(
  'config/environments/production.rb', /# config\.force_ssl = true/,
  'config.force_ssl = true'
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

#
# Backend Optional Gems
#

# attr_encrypted| encrypt model attributes
gem 'attr_encrypted', '~> 3.0.0' if yes?('Install attr_encrypted gem?')
# Interact with Amazon Web Services (S3, CloudFront, etc.)
gem 'aws-sdk' if yes?('Install aws-sdk gem?')
# city-state | library of US states and cities for forms
gem 'city-state' if yes?('Install city-state gem?')
# Cocoon for implementing forms for associated models.
gem 'cocoon' if yes?('Install cocoon gem for associated model forms?')
# Delayed Job Queue
installed_delayed_job = yes?('Install basic delayed_job queue?')
gem 'delayed_job_active_record' if installed_delayed_job
# A simple ActiveRecord mixin to add conventions for flagging records as
# discarded.
gem 'discard' if yes?('Install discard gem for, "soft deletes"?')
# fuzzily | inexact search matching
gem 'fuzzily' if yes?('Install fuzzily gem for, "fuzzy searches"?')
# geocoder | retrieve latitude and longitude for locations
gem 'geocoder' if yes?('Install geocoder gem?')
# gibbon | MailChimp e-mail marketing
gem 'gibbon' if yes?('Install gibbon for MailChimp integration?')
# Allow hashes of numeric IDs to be calculated to obfuscate sequential access
# to application records.
gem 'hashid-rails' if yes?('Install hashid-rails to obfuscate IDs?')
# koala | Facebook API access.
gem 'koala' if yes?('Install koala for Facebook API access?')
# mandrill-api | Mandrill (MailChimp) Transactional E-Mail
gem 'mandrill-api' if yes?('Install mandrill-api for transactional e-mail?')
# mechanize | web automation and scraping
gem 'mechanize' if yes?('Install mechanize for web automation and scraping?')
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
if yes?('Install two factor auth gem?')
  gem 'two_factor_authentication'
  gem 'rqrcode'
end

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

#
# Financial
#
if yes?('Do you need to install financial services?')
  # ach | write ACH transfer batch files
  gem 'ach' if yes?('Install ach gem for writing NACHA files?')
  # Monetize, for converting other objects into Money.
  gem 'monetize' if yes?('Install monetize for money handling?')
  # Plaid for enabling ACH payments
  gem 'plaid' if yes?('Install plaid for account authentication and info?')
  # stripe | payment processing
  gem 'stripe' if yes?('Install stripe for payment processing?')
end

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
  # rack-mini-profiler | profile page loading
  gem 'rack-mini-profiler', require: false
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
  # rubocop | static code analysis
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-performance'
  gem 'spring'
  # Remove SQLite from ALL environments. Only want it in development and test.
  gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\n/, ''
  gsub_file 'Gemfile', /^gem 'sqlite3'\n/, ''
end

# Rubocop Configuration File
create_file 'config/rubocop.yml', "AllCops:
  Exclude:
    - 'db/**/*'
    - 'bin/*'
  TargetRubyVersion: 2.7\n"

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
