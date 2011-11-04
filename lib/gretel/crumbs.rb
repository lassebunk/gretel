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
      
      def get_crumb(name, *params)
        raise "Crumb '#{name}' not found." unless all[name]
        
        @params = params # share the params so we can call it from link() and parent()
        @link = nil
        @parent = nil
        
        all[name].call(*params)
        Gretel::Crumb.new(@link, @parent)
      end
      
      def link(text, url)
        text = text.call(*@params) if text.is_a?(Proc)
        url = url.call(*@params) if url.is_a?(Proc)
        
        @link = Gretel::Link.new(text, url)
      end
      
      def parent(name, *params)
        name = name.call(*@params) if name.is_a?(Proc)

        params.each_with_index do |param, i|
          params[i] = param.call(&@params) if param.is_a?(Proc)
        end

        @parent = Gretel::Parent.new(name, *params)
      end
    end
  end
end