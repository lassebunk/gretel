module Gretel
  module Crumbs
    class << self
      def layout(&block)
        # Needs to be done here because Rails.application isn't set when this file is required
        # TODO: Can this be done otherwise?
        Gretel::Crumb.send :include, Rails.application.routes.url_helpers
        instance_eval &block
      end

      def crumb(key, &block)
        crumbs[key] = block
      end

      def crumbs
        @crumbs ||= {}
      end
    end
  end
end