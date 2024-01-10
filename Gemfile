source 'https://rubygems.org'
ruby '~> 2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5', require: false
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'delayed_job', "~> 4.1.1"
gem 'delayed_job_active_record', "~> 4.1.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# scheduler gem
gem 'rufus-scheduler'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc, require: false
# hidding configure strings to another yml file
gem 'figaro'
# to uploade picture
gem 'carrierwave'
gem 'rmagick', require: false
gem 'chosen-rails'

# for turbolink js load solution
gem 'jquery-turbolinks'

# Use ActiveModel has_secure_password
 gem 'bcrypt', '~> 3.1.15'

#Add a comment summarizing the current schema to the top or bottom of model
gem 'annotate'

gem 'roo'
gem 'roo-xls'
# Use Unicorn as the app server
# gem 'unicorn'

#PG for heroku
#gem 'pg'
#gem 'validates_email_format_of'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop exe+tion and get a debugger console
  gem 'byebug', require: false
  gem 'rspec-rails', '~> 3.5'
  # gem 'factory_girl_rails'
  gem 'faker'
  gem 'simplecov', :require => false

  gem 'capistrano', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', require: false
  gem "letter_opener"
end

gem 'barby'
gem 'chunky_png'

# use for authentications
gem 'devise'
gem 'devise_invitable'
gem 'will_paginate'

# for reporting pdf, word export
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'htmltoword'
gem 'cancancan'
gem 'inherited_resources', '~> 1.7'

gem 'gem_bench', :group => :console

# currency list
gem 'currency_select'
gem 'country_select'
gem 'friendly_id', '~> 5.1.0'

# for geocoding ones location
gem 'geocoder'

gem 'activeadmin', github: 'activeadmin'

# get your Rails variables in your js
gem 'gon'
gem 'nested_form'
gem "acts_as_archival"
gem 'paranoia'

group :production do
  gem 'unicorn'
end
gem 'exception_notification'