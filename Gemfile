source "http://rubygems.org"

gemspec

rails_version = ENV['RAILS_VERSION'] || '>= 0'
gem 'rails', rails_version == 'master' ? { github: 'rails/rails' } : rails_version
