source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'rails', '~> 5.1.4'
gem 'httparty'
gem 'fog'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'groupdate'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'whenever', :require => false
gem 'yaml_db'
gem 'kaminari'
gem 'carrierwave'
gem 'carrierwave-imageoptimizer'
gem 'mini_magick'
gem 'sprockets-rails'
gem 'popper_js', '~> 1.12.9', '>= 1.11.1'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'jquery-rails', '~> 4.3.1'
gem 'bootstrap', '~> 4.1.0'
gem 'bootstrap_form'
gem 'font-awesome-rails'
gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'devise'
gem 'better_errors', group: :development
gem 'binding_of_caller'
gem 'cancancan'
gem 'pry-rails', :group => :development
gem 'figaro'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :production do
  gem 'rails_12factor'
end


# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
