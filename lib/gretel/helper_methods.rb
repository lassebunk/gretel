module Gretel
  module HelperMethods
    include ActionView::Helpers::UrlHelper
    def controller # hack because ActionView::Helpers::UrlHelper needs a controller method
    end
    
    def self.included(base)
      base.send :helper_method, :breadcrumb_for, :breadcrumb
    end
    
    def breadcrumb(*args)
      options = args.extract_options!
      name, object = args[0], args[1]
      
      if name
        @_breadcrumb_name = name
        @_breadcrumb_object = object
      else
        if @_breadcrumb_name
          crumb = breadcrumb_for(@_breadcrumb_name, @_breadcrumb_object, options)
        elsif options[:show_root_alone]
          crumb = breadcrumb_for(:root, options)
        end
      end
      
      if crumb && options[:pretext]
        crumb = options[:pretext].html_safe + " " + crumb
      end
      
      crumb
    end
    
    def breadcrumb_for(*args)
      options = args.extract_options!
      link_last = options[:link_last]

      name, object = args[0], args[1]
      
      crumbs = []
      
      crumb = Crumbs.get_crumb(name, object)
      while link = crumb.links.shift
        crumbs << link_to(link.text, link.url)
      end
      
      while crumb = crumb.parent
        last_parent = crumb.name
        crumb = Crumbs.get_crumb(crumb.name, crumb.object)
        while link = crumb.links.shift
          crumbs.unshift link_to(link.text, link.url)
        end
      end
      
      if options[:autoroot] && name != :root && last_parent != :root
        crumb = Crumbs.get_crumb(:root)
        while link = crumb.links.shift
          crumbs.unshift link_to(link.text, link.url)
        end
      end
      
      crumbs.join(" " + (options[:separator] || "&gt;") + " ").html_safe
    end
    
    # TODO: use_microformats + link_last
  end
end