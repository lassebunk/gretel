module Gretel
  class Crumbs
    class << self
      include Rails.application.routes.url_helpers
      include ActionView::Helpers::UrlHelper
      def controller # hack because Rails.application.routes.url_helpers needs a controller method
      end
      def layout(&block)
        instance_eval &block
      end
      
      def all
        @crumbs ||= {}
      end

      def crumb(name, &block)
        all[name] = block
      end
      
      def get_crumb(name, object = nil)
        raise "Crumb '#{name}' not found." unless all[name]
        all[name].call(object)
        Gretel::Crumb.new(@link, @parent)
      end
      
      def link(text, url)
        @link = Gretel::Link.new(text, url)
        @parent = nil
      end
      
      def parent(name, object = nil)
        @parent = Gretel::Parent.new(name, object)
      end
    end
  end
end