require "simplecov"
require "simplecov-erb"

SimpleCov.start do
  enable_coverage :branch
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::ERBFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
end

SimpleCov.minimum_coverage 100

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("dummy/config/environment.rb",  __dir__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }
