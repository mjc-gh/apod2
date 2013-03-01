source 'https://rubygems.org'

gem 'rails', '4.0.0.beta1'
gem 'yajl-ruby'

gem 'haml', github: 'haml/haml'
gem 'haml-rails'

gem 'execjs'
gem 'therubyracer'

gem 'httparty', require: false
gem 'nokogiri', require: false

gem 'jquery-rails'

group :production do
  gem 'puma'
  gem 'pg'
end

group :assets do
  gem 'uglifier', '>= 1.3.0'

  gem 'sass-rails', '~> 4.0.0.beta1'
  gem 'compass-rails', github: 'milgner/compass-rails', branch: 'rails4'

  gem 'animate'
end

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'ruby-prof'

  gem 'contest'

  gem 'mocha', :require => false
  gem 'fakeweb'

  gem 'guard'
  gem 'guard-minitest'

  gem 'rb-inotify', '~> 0.9.0'
end

group :development do
  gem 'quiet_assets'
end
