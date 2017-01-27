# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gretel/version'

Gem::Specification.new do |gem|
  gem.name          = "gretel"
  gem.version       = Gretel::VERSION
  gem.authors       = ["Lasse Bunk"]
  gem.email         = ["lassebunk@gmail.com"]
  gem.description   = %q{Gretel is a Ruby on Rails plugin that makes it easy yet flexible to create breadcrumbs.}
  gem.summary       = %q{Flexible Ruby on Rails breadcrumbs plugin.}
  gem.homepage      = "http://github.com/lassebunk/gretel"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 3.1.0"
  gem.add_development_dependency "sqlite3"
end
