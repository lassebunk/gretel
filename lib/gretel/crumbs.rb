module Gretel
  module Crumbs
    class << self
      include Resettable

      # Stores the supplied block for later use.
      def crumb(key, &block)
        crumbs[key] = block
      end

      # Returns a hash of all stored crumb blocks.
      def crumbs
        @crumbs ||= {}
      end

      # Returns true if a crumb with the given key has been set.
      def crumb_defined?(key)
        crumbs.has_key?(key)
      end

      # Loads the breadcrumb configuration files.
      def load_breadcrumbs
        @crumbs = {}

        loaded_file_mtimes.clear
        breadcrumb_files.each do |file|
          instance_eval open(file).read, file
          loaded_file_mtimes << File.mtime(file)
        end

        @loaded = true
      end

      # Reloads the breadcrumb configuration files if they have changed.
      def reload_if_needed
        load_breadcrumbs if reload?
      end

      # Returns true if a breadcrumbs reload is needed based on configuration file changes.
      def reload?
        return true unless loaded?
        return false unless Gretel.reload_environments.include?(Rails.env)

        loaded_file_mtimes != breadcrumb_files.map { |file| File.mtime(file) }
      end

      # Returns true if the breadcrumb configuration files have been loaded.
      def loaded?
        !!@loaded
      end

      # List of breadcrumb configuration files.
      def breadcrumb_files
        Dir[*Gretel.breadcrumb_paths]
      end

    private

      def loaded_file_mtimes
        @loaded_file_mtimes ||= []
      end
    end
  end
end
