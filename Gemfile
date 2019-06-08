# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem "actionview", ">= 5.1.6"
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'better_errors', group: :development
gem 'binding_of_caller'
gem 'bootstrap', '~> 4.1.0'
gem 'bootstrap_form'
gem 'cancancan'
gem 'carrierwave'
gem 'carrierwave-imageoptimizer'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'figaro'
gem 'fog'
gem 'font-awesome-rails'
gem 'groupdate'
gem 'httparty'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3.1'
gem 'kaminari'
gem "loofah", ">= 2.2.3"
gem 'mini_magick'
gem 'minitest'
gem 'pg', '~> 0.18'
gem 'popper_js', '~> 1.12.9', '>= 1.11.1'
gem 'pry-rails', group: :development
gem 'puma'
gem 'rails', '~> 5.1.6'
gem 'rack', '>= 2.0.6'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'rubocop', require: false
gem 'sass-rails', '~> 5.0'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'sprockets-rails'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '~> 0.12.3'
gem 'yaml_db'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', require: false
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'rails_12factor'
end
