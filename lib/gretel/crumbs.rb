module Gretel
  class Crumbs
    class << self
      def controller # hack because Rails.application.routes.url_helpers needs a controller method
      end
      
      def layout(&block)
        # needs to be done here because Rails.application isn't set when this file is required
        self.class.send :include, Rails.application.routes.url_helpers
        self.class.send :include, ActionView::Helpers::UrlHelper
        
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
        
        @object = object # share the object so we can call it from link() and parent()
        @link = nil
        @parent = nil
        
        all[name].call(object)
        Gretel::Crumb.new(@link, @parent)
      end
      
      def link(text, url, options = {})
        text = text.call(@object) if text.is_a?(Proc)
        url = url.call(@object) if url.is_a?(Proc)
        
        @link = Gretel::Link.new(text, url, options)
      end
      
      def parent(name, object = nil)
        name = name.call(@object) if name.is_a?(Proc)
        object = object.call(@object) if object.is_a?(Proc)

        @parent = Gretel::Parent.new(name, object)
      end
    end
  end
end