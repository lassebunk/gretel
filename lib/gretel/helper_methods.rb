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
      options[:link_last] = true
      separator = (options[:separator] || "&gt;").html_safe

      name, object = args[0], args[1]
      
      crumb = Crumbs.get_crumb(name, object)
      if link_last
        out = link_to_if(link_last, crumb.link.text, crumb.link.url, crumb.link.options.merge(:class => "current"))
      else
        if options[:use_microformats]
          out = content_tag(:span, crumb.link.text, :class => "current", :itemprop => "title")
        else
          out = content_tag(:span, crumb.link.text, :class => "current")
        end
      end
      
      while parent = crumb.parent
        last_parent = parent.name
        crumb = Crumbs.get_crumb(parent.name, parent.object)
        if options[:use_microformats]
          out = content_tag(:div, link_to(content_tag(:span, crumb.link.text, :itemprop => "title"), crumb.link.url, crumb.link.options.merge(:itemprop => "url")) + " ", :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb") + " " + separator + " " + out
        else
          out = link_to(crumb.link.text, crumb.link.url, crumb.link.options) + " " + separator + " " + out
        end
      end
      
      # TODO: Refactor this
      if options[:autoroot] && name != :root && last_parent != :root
        crumb = Crumbs.get_crumb(:root)
        if options[:use_microformats]
          out = content_tag(:div, link_to(content_tag(:span, crumb.link.text, :itemprop => "title"), crumb.link.url, crumb.link.options.merge(:itemprop => "url")) + " ", :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb") + " " + separator + " " + out
        else
          out = link_to(crumb.link.text, crumb.link.url, crumb.link.options) + " " + separator + " " + out
        end
      end
      
      out
    end
  end
end