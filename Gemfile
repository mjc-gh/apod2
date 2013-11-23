ruby '2.0.0'
source 'https://rubygems.org'

gem 'rails', '4.0.0.beta1'
gem 'haml-rails'

gem 'execjs'
gem 'therubyracer'

gem 'httparty', require: false
gem 'nokogiri', require: false

gem 'jquery-rails'

group :heroku do
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :production do
  gem 'puma'
  gem 'pg'
end

group :assets do
  gem 'uglifier', '>= 1.3.0'

  gem 'sass-rails'
  gem 'compass-rails'

  gem 'animate'
end

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'mocha', require: false

  gem 'guard'
  gem 'guard-minitest'

  gem 'rb-inotify', '~> 0.9.0'

  gem 'fakeweb'
  gem 'ruby-prof'
end

group :development do
  gem 'quiet_assets'
end
