require 'gretel/version'
require 'gretel/crumbs'
require 'gretel/crumb'
require 'gretel/link'
require 'gretel/trail'
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
      puts message
      Rails.logger.warn message
    end

    # Array of Rails environment names with automatic configuration reload. Default is +["development"]+.
    def reload_environments
      @reload_environments ||= ["development"]
    end

    # Sets the Rails environment names with automatic configuration reload. Default is +["development"]+.
    attr_writer :reload_environments

    # Resets all changes made to +Gretel+, +Gretel::Crumbs+, and +Gretel::Trail+. Used for testing.
    def reset!
      instance_variables.each { |var| remove_instance_variable var }
      Crumbs.reset!
      Trail.reset!
    end
  end
end

ActionView::Base.send :include, Gretel::ViewHelpers