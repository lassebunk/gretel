module Gretel
  module HelperMethods
    include ActionView::Helpers::UrlHelper
    def controller # hack because ActionView::Helpers::UrlHelper needs a controller method
    end

    def self.included(base)
      base.send :helper_method, :breadcrumb_for, :breadcrumb, :render_breadcrumbs, :crumb_link
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
      
      separator = (options[:separator] || "&gt;").html_safe    
      name, object = args[0], args[1]

      crumb_list_for(name, object, options)
        .map {|crumb| crumb_link(crumb) }
        .join(' ' + separator + ' ').html_safe
    end

    def render_breadcrumbs(partial, *args)
      options = args.extract_options!

      if @_breadcrumb_name
        crumbs = crumb_list_for(@_breadcrumb_name, @_breadcrumb_object, options)
      elsif options[:show_root_alone]
        crumbs = crumb_list_for(:root, nil, options)
      end

      render_to_string(partial: partial, locals: {crumbs: crumbs}).html_safe
    end

    def crumb_link(crumb)
      if crumb.link.url.nil?
        crumb.link.text
      else
        link_to(crumb.link.text, crumb.link.url, crumb.link.options)
      end
    end

    private
    def crumb_list_for(name, object, options)
      crumbs = []

      crumb = Gretel::Crumbs.get_crumb(name, object)
      (crumbs << crumb) if options[:link_last]

      while parent = crumb.parent
        last_parent = parent.name
        crumb = Gretel::Crumbs.get_crumb(parent.name, parent.object)
        crumbs << crumb
      end

      if options[:autoroot] && name != :root && last_parent != :root
        crumbs << Gretel::Crumbs.get_crumb(:root)
      end

      crumbs.reverse
    end   
  end
end