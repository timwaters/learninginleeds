source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use sqlite3 as the database for Active Record
# em 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#gem 'therubyracer', '~> 0.12.3'

#gem 'mini_racer', '~> 0.8.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'sprockets-rails' 
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'activeadmin', '~> 2.14'
gem 'has_scope', '~> 0.8.0'
gem 'devise', '~> 4.9'
gem 'cancancan', '~> 1.10'

gem 'activerecord-import'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'rails-controller-testing'
gem 'leaflet-rails'
gem 'text'
gem 'will_paginate', '~> 3.1.0'

gem 'pg'
gem 'activerecord-postgis-adapter', '~> 8.0.3'
#gem 'activerecord-postgis-adapter'
gem 'pg_search'
gem 'ffi', '~> 1.17.4'

gem 'coffee-rails'

gem 'httparty'
#gem "paperclip", "~> 5.2.1"
gem "kt-paperclip", "~> 6.4.1"

gem "actionpack-page_caching"
gem "browser"

gem "osrm_text_instructions", "~> 0.1"

gem "kramdown"
gem "sanitize"

gem 'activeadmin_simplemde'

gem 'pandoc-ruby'
gem 'nokogiri'

gem "image_processing", ">= 1.2"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', "~> 4.2.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mimemagic', '~> 0.3.10'
