source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgreSQL as the database for Active Record
gem 'pg', '>= 0.18.4'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0'
gem 'font-awesome-sass', '~> 4.4.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'angularjs-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.0'
# Bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '>= 0.4.0', group: :doc

# versions
gem 'bump', github: 'pavolzbell/bump'

# Authorization
gem 'cancancan'

# Crawling
gem 'nokogiri'
gem 'mechanize'
# OAuth2 provider functionality
gem 'doorkeeper'
gem 'oauth2'

gem 'grape'

gem 'unicorn'

# A Ruby client library for Redis.
gem 'redis', '>=3.2'

gem 'resque-web', require: 'resque_web'
gem 'resque-scheduler', '4.3.0'
gem 'resque-pool', '0.6.0'
gem 'resque-retry', '1.5.0'
gem 'resque-rollbar', '~> 0.4.0'

# Boostrap
gem 'bootstrap-sass', '>= 3.3.6'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.43'

gem 'devise', '>= 3.4.1'

# Pagination
gem 'kaminari'

# Paranoia
gem 'paranoia', '>= 2.0'

# Elastic
gem 'elasticsearch-rails', '>= 0.1.9'
gem 'elasticsearch-model', '>= 0.1.9'
gem 'elasticsearch-persistence', require: 'elasticsearch/persistence/model'

gem 'nestive'

# XLSX
gem 'axlsx', '= 2.0.1'
gem 'axlsx_rails'

gem 'http'
gem 'monetize'
# Test suite related gems
group :development, :test do
  gem 'rspec', '>= 3.0'
  gem 'rspec-rails', '>= 3.5'
  gem 'capybara'

  gem 'factory_girl_rails', '>= 4.5'
  gem 'database_cleaner','>= 1.5.3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'awesome_print'
end

group :test do
  gem 'resque_spec'
  gem 'timecop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 2.0'

  gem 'capistrano', '3.6.1'
  gem 'capistrano-ext', '1.2.1'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem "capistrano-resque", "~> 0.2.2", require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'better_errors'
end
