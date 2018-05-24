source 'https://rubygems.org'

ruby '2.4.4'

gem 'rails', '5.2.0'

gem 'pg'

gem 'puma', '~> 3.11.4'

gem 'chartkick'

gem 'webpacker', '~> 3.5'

gem 'devise',             '~> 4.4.3'
gem 'omniauth',           '~> 1.8.1'
gem 'omniauth-github'
gem 'omniauth-twitter'

gem 'pundit'

gem 'actionview-encoded_mail_to'
gem 'coderay', '~> 1.0'
gem 'country_select', '~> 1.3.1'
gem 'haml', '~> 5.0.4'
gem 'haml-rails', '~> 1.0.0'
gem 'redcarpet', '~> 3.4.0'
gem 'simple_form', '~> 4.0.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'draper', '~> 3.0.1'
gem 'responders', '~> 2.4.0'

gem 'groupdate'

gem 'nokogiri', '~> 1.8.1'

gem 'bootsnap', '>= 1.1.0', require: false

group :development do
  gem 'foreman', '~> 0.84', require: false
  gem 'rubocop', '~> 0.55', require: false

  gem 'annotate'
  gem 'html2haml', '~> 2.2.0'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'launchy'
  gem 'rack-mini-profiler'

  gem 'spring'
  gem 'spring-commands-rspec', require: false
  gem 'web-console', '~> 2.0'

  gem 'guard'
  gem 'guard-livereload', '~> 2.1.1'
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-rescue'
end

group :development, :test do
  gem 'dotenv-rails'

  gem 'factory_bot_rails', '~> 4.8'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '~> 3.0'
  gem 'capybara_table', git: 'https://github.com/myabc/capybara_table.git'
  gem 'selenium-webdriver'

  gem 'database_cleaner', '~> 1.6.0'

  gem 'rails-controller-testing'
  gem 'timecop'

  gem 'simplecov', require: false
end

group :production do
  gem 'rack-timeout', '~> 0.2.4'
end
