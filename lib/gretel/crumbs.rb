module Gretel
  module Crumbs
    class << self
      # Lay out the breadcrumbs.
      #
      # Example:
      #   Gretel::Crumbs.layout do
      #     crumb :root do
      #       link "Home", root_path
      #     end
      #   end
      def layout(&block)
        instance_eval &block
      end

      # Stores the supplied block for later use.
      def crumb(key, &block)
        crumbs[key] = block
      end

      # Returns an array of all stored crumb blocks.
      def crumbs
        @crumbs ||= {}
      end

      # Returns true if a crumb with the given key has been set.
      def crumb_defined?(key)
        crumbs.has_key?(key)
      end

      # Resets all changes made to +Gretel::Crumbs+. Used for testing.
      def reset!
        instance_variables.each { |var| remove_instance_variable var }
      end
    end
  end
end
