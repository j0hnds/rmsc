source 'http://rubygems.org'

gem 'rails', '3.2.6'

gem 'prawn' #, :submodules => true
gem 'prawnto'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "will_paginate", "~> 3.0"

gem 'jquery-rails', '~> 2.0.2'

group :assets do
  gem 'sass-rails'  , '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier'    , '>= 1.2.4'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test, :cucumber do
  gem 'capybara', '1.1.2'
  # gem 'cucumber-rails', '1.3.0', :require => false
  # gem 'cucumber', '1.2.0'
  # gem 'selenium-webdriver'
  gem 'cover_me', '>= 1.2.0'
  gem 'rspec-rails', '2.10.1'
  gem 'database_cleaner'
  gem 'factory_girl', '>= 3.3.0'
  gem 'factory_girl_rails', '~> 3.3.0'
  gem 'rack-test', '0.6.1'
  # gem 'launchy', '2.1.0'
  gem 'jasmine', '1.2.0'
  gem 'spork-rails', '3.2.0'
end

group :development do
  gem 'thin'
  gem 'spork-rails', '3.2.0'
end
