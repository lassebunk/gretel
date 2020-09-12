require 'gretel/version'
require 'gretel/resettable'
require 'gretel/railtie'

module Gretel
  class << self
    include Resettable

    # Returns the path from with breadcrumbs are loaded. Default is +config/breadcrumbs.rb+
    # in the app and all loaded engines. Breadcrumbs set in the app will override
    # breadcrumbs set in engines.
    def breadcrumb_paths
      @breadcrumb_paths ||= begin
        engines = Rails::Engine.subclasses.map(&:instance)

        engine_roots = engines.map { |e| e.config.root }
        
        [*engine_roots, Rails.root].map do |root|
          [root.join("config", "breadcrumbs.rb"),
           root.join("config", "breadcrumbs", "**", "*.rb"),
           root.join("app", "views", "breadcrumbs", "**", "*.rb")]
        end.flatten
      end
    end

    # Sets the path from with breadcrumbs are loaded. Default is +config/breadcrumbs.rb+.
    def breadcrumb_paths=(paths)
      @breadcrumb_paths = paths
    end

    # Array of Rails environment names with automatic configuration reload. Default is +["development"]+.
    def reload_environments
      @reload_environments ||= ["development"]
    end

    # Registers a style for later use.
    # 
    #   Gretel.register_style :ul, { container_tag: :ul, fragment_tag: :li }
    def register_style(style, options)
      Gretel::Renderer.register_style style, options
    end

    # Sets the Rails environment names with automatic configuration reload. Default is +["development"]+.
    attr_writer :reload_environments

    # Yields this +Gretel+ to be configured.
    # 
    #   Gretel.configure do |config|
    #     config.reload_environments << "staging"
    #   end
    def configure
      yield self
    end
  end
end
