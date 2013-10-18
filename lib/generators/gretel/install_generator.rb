require 'rails/generators'

module Gretel
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    desc "Creates a sample configuration file in config/breadcrumbs.rb"
    def create_config_file
      copy_file "breadcrumbs.rb", "config/breadcrumbs.rb"
    end
  end
end