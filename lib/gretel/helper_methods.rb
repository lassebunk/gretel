module Gretel
  module HelperMethods
    include ActionView::Helpers::UrlHelper
    def controller # hack because ActionView::Helpers::UrlHelper needs a controller method
    end
    
    def self.included(base)
      base.send :helper_method, :breadcrumbs, :breadcrumb
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
      
      if crumb
        if options[:pretext]
          crumb = options[:pretext].html_safe + crumb
        end
        if options[:posttext]
          crumb = crumb + options[:posttext].html_safe
        end
      end
      
      if crumb
        content_tag(:div, crumb, :class => "breadcrumbs", :id => options[:id])
      else
        ""
      end
    end
    
    def breadcrumbs(*args)
      options = args.extract_options!
      
      if @_breadcrumb_name
        links = []

        crumb = Crumbs.get_crumb(@_breadcrumb_name, @_breadcrumb_object)
        while link = crumb.links.pop
          links.unshift ViewLink.new(link.text, link.url, link.options)
        end

        while crumb = crumb.parent
          last_parent = crumb.name
          crumb = Crumbs.get_crumb(crumb.name, crumb.object)
          while link = crumb.links.pop
            links.unshift ViewLink.new(link.text, link.url, link.options)
          end
        end

        if options[:autoroot] && @_breadcrumb_name != :root && last_parent != :root
          crumb = Crumbs.get_crumb(:root)
          while link = crumb.links.pop
            links.unshift ViewLink.new(link.text, link.url, link.options)
          end
        end

        current_link = links.pop

        out = []
        while link = links.shift
          out << ViewLink.new(link.text, link.url, link.options)
        end

        if current_link
          out << ViewLink.new(current_link.text, current_link.url, current_link.options, true)
        end
      else
        out = []
      end

      out
    end
    
    def breadcrumb_for(*args)
      options = args.extract_options!
      name, object = args[0], args[1]
      
      links = breadcrumbs(name, object, options)
      
      current_link = links.pop
      
      out = []
      while link = links.shift
        out << get_crumb(link.text, link.url, options[:semantic], nil, link.options)
      end
      
      if current_link
        if options[:link_last] || options[:link_current]
          out << get_crumb(current_link.text, current_link.url, options[:semantic], "current", current_link.options)
        else
          out << get_crumb(current_link.text, nil, options[:semantic], "current")
        end
      end
      
      out.join(options[:separator] || " &gt; ").html_safe
    end
    
    def get_crumb(text, url, semantic, css_class, options = {})
      if url.blank?
        if semantic
          content_tag(:div, content_tag(:span, text, :class => css_class, :itemprop => "title"), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
        else
          if css_class
            content_tag(:span, text, :class => css_class)
          else
            text
          end
        end
      else
        options.merge! :class => (options[:class] ? options[:class] + " " : "") + css_class if css_class
        if semantic
          content_tag(:div, link_to(content_tag(:span, text, :itemprop => "title"), url, options.merge(:itemprop => "url")), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
        else
          link_to(text, url, options)
        end
      end
    end
  end
end