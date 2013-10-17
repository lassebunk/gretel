require 'gretel/version'
require 'gretel/crumbs'
require 'gretel/crumb'
require 'gretel/link'
require 'gretel/trail'
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

    # Param to contain trail. See +Gretel::Trail.trail_param+ for details.
    def trail_param
      Gretel::Trail.trail_param
    end

    # Sets the trail param. See +Gretel::Trail.trail_param+ for details.
    def trail_param=(param)
      Gretel::Trail.trail_param = param
    end

    # Trail store. See +Gretel::Trail.store+ for details.
    def trail_store
      Gretel::Trail.store
    end

    # Sets the trail store. See +Gretel::Trail.store+ for details.
    def trail_store=(store)
      Gretel::Trail.store = store
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

    # Sets the Rails environment names with automatic configuration reload. Default is +["development"]+.
    attr_writer :reload_environments

    # Yields this +Gretel+ to be configured.
    # 
    #   Gretel.configure do |config|
    #     config.trail_param = :other_param
    #   end
    def configure
      yield self
    end

    # Resets all changes made to +Gretel+, +Gretel::Crumbs+, and +Gretel::Trail+. Used for testing.
    def reset!
      instance_variables.each { |var| remove_instance_variable var }
      Crumbs.reset!
      Trail.reset!
    end
  end
end

ActionView::Base.send :include, Gretel::ViewHelpers