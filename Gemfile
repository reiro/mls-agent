source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'devise'
gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'redis', '~>3.2'

gem 'httparty', '~> 0.13.7'

gem 'foreman', '~> 0.82.0'

gem 'rets', '~> 0.10.0'
gem 'nokogiri', '~> 1.6', '>= 1.6.8'
gem 'slim-rails', '~> 3.1', '>= 3.1.1'
gem 'carrierwave', '~> 0.11.2'
gem 'mini_magick', '~> 4.5.1'
gem 'faker', '~> 1.6', '>= 1.6.3'

gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.1'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
