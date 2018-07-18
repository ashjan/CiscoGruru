source 'https://rubygems.org'

ruby '2.2.6'

gem 'rails', '4.2.8'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bcrypt', '~> 3.1.7'

gem 'bootstrap-sass', '~> 3.3.3'
gem 'handlebars_assets'

# For memcached
gem 'dalli'

# Omniauth {{{
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
gem 'omniauth-yandex'
# TODO:
# gem 'omniauth-dropbox-oauth2'
# }}}

group :test do
  gem 'shoulda'
  gem 'simplecov', require: false
end

group :production do
  #gem 'unicorn'
  gem 'pg'
end

group :development do
  gem 'spring'
  gem 'quiet_assets'
  gem 'annotate', '>=2.6.0'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'guard'
  gem 'guard-minitest'
end

group :test, :development do
  # n+1 queries
  gem 'bullet'
  gem 'jasmine-rails'
end

gem 'rack-attack'

# For admin panel
gem 'kaminari'
gem 'chartkick'
# gem 'groupdate'
gem 'dateslices'
gem 'useragent'

# For windows and jRuby?
 gem 'tzinfo-data', platforms: [:mswin, :mingw]

###########gem 'cosql', '0.1.25', git: 'git@gitlab.com:cenan.ozen/cosql'
# gem 'cosql', path: '/Users/cenan/projects/dbdesigner/cosql'

# External
gem 'rollbar', '~> 2.14.1'

# Deployment
gem 'mina-unicorn', '0.5.0', require: false

# Cron
gem 'whenever', require: false
gem 'delayed_job_active_record'


gem 'redcarpet'

