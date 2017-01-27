#
# Core Gems
#

#
# Authorization
#
gem 'devise'
generate 'devise:install'
model_name = ask('What would you like the user model to be called? [User]')
model_name = 'User' if model_name.blank?
generate 'devise', model_name
generate 'devise:views' if yes?('Install Devise view files?')
# Access Control
gem 'pundit'
generate 'pundit:install'

# Setup Static Home Page
generate 'controller', 'static home'
route "root to: 'static#home'"
gsub_file 'config/routes.rb', /^  get 'static\/home'\n$/, ''


gem 'jquery-turbolinks'
gem 'turbolinks'

# Twitter Bootstrap
gem 'bootstrap', '~> 4.0.0.alpha6'
# Pagination
gem 'kaminari'
# Genrate the default views from Kaminari
generate 'kaminari:views default'
# Ember - Front End Framework
gem 'ember-rails'
# Twilio for SMS and Telephone Communication
gem 'twilio-ruby'

# Heroku
gem_group :production do
  gem 'rails_12factor'
  gem 'pg'
end

gem_group :development do
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
  # Remove SQLite from ALL environments. Only want it in development and test.
  gsub_file 'Gemfile', /^# Use sqlite3 as the database for Active Record\n/, ''
  gsub_file 'Gemfile', /^gem 'sqlite3'\n/, ''
  # Add SQLite to development and test.
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

# Run
rake 'db:migrate db:seed'
