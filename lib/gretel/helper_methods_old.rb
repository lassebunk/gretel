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
      if crumb.links
        last_link = crumb.links.pop
        #if link_last
        #  out = out + " " + separator + " " + link_to_if(link_last, last_link.text, last_crumb.link.url, last_crumb.options.merge(:class => "current"))
        #else
        #  if options[:use_microformats]
        #    out = out + " " + separator + " " + content_tag(:span, last_link.text, :class => "current", :itemprop => "title")
        #  else
            crumbs << content_tag(:span, last_link.text, :class => "current")
        #  end
        #end
      end
      
      last_parent = nil
      while parent = crumb.parent
        last_parent = parent.name
        crumb = Crumbs.get_crumb(parent.name, parent.object)
        
        if crumb.links
            while link = crumb.links.shift
              if link
              #if options[:use_microformats]
              #  parents = out + " " + separator + " " + content_tag(:div, link_to(content_tag(:span, link.text, :itemprop => "title"), link.url, link.options.merge(:itemprop => "url")) + " ", :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
              #else
                crumbs.shift link_to(link.text, link.url, link.options)
              #end
              end
            end
        end
      end
      
      # TODO: Refactor this
      if options[:autoroot] && name != :root && last_parent != :root
        crumb = Crumbs.get_crumb(:root)
        if crumb.links
          while link = crumb.links.shift
            #if options[:use_microformats]
            #  out = content_tag(:div, link_to(content_tag(:span, link.text, :itemprop => "title"), link.url, link.options.merge(:itemprop => "url")) + " ", :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb") + " " + separator + " " + out
            #else
              crumbs.unshift link_to(link.text, link.url, link.options)
            #end
          end
        end
      end
      
      crumbs.join(" " + (options[:separator] || "&gt;") + " ").html_safe
    end
  end
end