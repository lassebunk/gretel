require 'rails/generators'

module Gretel
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    desc "Creates a sample configuration file in config/breadcrumbs.rb"
    def create_config_file
      copy_file "breadcrumbs.rb", "config/breadcrumbs.rb"
    end

    desc "Creates an initializer with trail secret"
    def create_initializer
      initializer "gretel.rb" do
        %{Gretel::Trail::UrlStore.secret = '#{SecureRandom.hex(64)}'}
      end
    end
  end
end