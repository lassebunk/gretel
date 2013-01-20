require 'rails/generators'

module Gretel
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    desc "Creates an initializer for breadcrumbs in config/initializers/breadcrumbs.rb"
    def create_initializer
      copy_file "initializer.rb", "config/initializers/breadcrumbs.rb"
    end
  end
end