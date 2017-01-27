source "https://rubygems.org"

gem "gretel",  :path => ".."

gem "rails", "~> 4.0.0"
gem "sqlite3"

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'test-unit', '~> 3.0' if RUBY_VERSION >= "2.2"
