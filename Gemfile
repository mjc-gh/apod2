source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'yajl-ruby'
gem 'haml-rails'
gem 'jquery-rails'

gem 'execjs'
gem 'therubyracer'

gem 'httparty', require: false
gem 'nokogiri', require: false

group :production do
  gem 'puma'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3'
end

group :test do
  # for gopher tests
  gem 'contest'

  gem 'mocha', :require => false
  gem 'fakeweb'

  gem 'guard'
  gem 'guard-minitest'

  gem 'ruby-prof'
  gem 'rb-inotify', '~> 0.8.8'
end

group :development do
  gem 'quiet_assets'
end
