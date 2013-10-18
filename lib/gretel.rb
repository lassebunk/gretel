require 'gretel/version'
require 'gretel/crumbs'
require 'gretel/crumb'
require 'gretel/link'
require 'gretel/renderer'
require 'gretel/view_helpers'
require 'gretel/deprecated'

module Gretel
  class << self
    # Returns the path from with breadcrumbs are loaded. Default is +config/breadcrumbs.rb+.
    def breadcrumb_paths
      @breadcrumb_paths ||= [Rails.root.join("config", "breadcrumbs.rb"), Rails.root.join("config", "breadcrumbs", "**", "*.rb")]
    end

    # Sets the path from with breadcrumbs are loaded. Default is +config/breadcrumbs.rb+.
    def breadcrumb_paths=(paths)
      @breadcrumb_paths = paths
    end

    # Whether to suppress deprecation warnings.
    def suppress_deprecation_warnings?
      !!@suppress_deprecation_warnings
    end

    # Sets whether to suppress deprecation warnings.
    def suppress_deprecation_warnings=(value)
      @suppress_deprecation_warnings = value
    end

    # Shows a deprecation warning.
    def show_deprecation_warning(message)
      return if suppress_deprecation_warnings?
      message = "[Gretel] #{message}"
      puts message
      Rails.logger.warn message
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

    # Resets all changes made to +Gretel+, +Gretel::Crumbs+, and +Gretel::Trail+. Used for testing.
    def reset!
      instance_variables.each { |var| remove_instance_variable var }
      Crumbs.reset!
    end
  end
end

Gretel.configure do |config|
  # Default style
  config.register_style :default, { container_tag: :div, separator: " &rsaquo; " }

  # Ordered list
  config.register_style :ol, { container_tag: :ol, fragment_tag: :li }

  # Unordered list
  config.register_style :ul, { container_tag: :ul, fragment_tag: :li }

  # Twitter Bootstrap
  config.register_style :bootstrap, { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", current_class: "active" }
end

ActionView::Base.send :include, Gretel::ViewHelpers