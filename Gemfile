source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.2'
gem 'haml-rails'

gem 'execjs'
gem 'therubyracer'

gem 'httparty', require: false
gem 'nokogiri', require: false

gem 'jquery-rails'

gem 'uglifier', '>= 1.3.0'

gem 'sass-rails', github: 'zakelfassi/sass-rails'

gem 'compass', '~> 1.0.0.alpha.19'
gem 'compass-rails'

group :development do
  gem 'quiet_assets'

  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-livereload', require: false

  gem 'rack-livereload'
end

group :test do
  gem 'mocha', require: false

  gem 'rb-inotify', '~> 0.9.0'

  gem 'fakeweb'
  gem 'ruby-prof'
end

group :heroku do
  gem 'rails_log_stdout',       github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'puma'
  gem 'pg'
end
