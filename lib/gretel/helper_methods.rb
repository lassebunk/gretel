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
      
      if crumb && options[:pretext]
        crumb = options[:pretext].html_safe + " " + crumb
      end
      
      crumb
    end
    
    def breadcrumbs(*args)
      options = args.extract_options!
      
      if @_breadcrumb_name
        links = []

        crumb = Crumbs.get_crumb(@_breadcrumb_name, @_breadcrumb_object)
        while link = crumb.links.pop
          links.unshift ViewLink.new(link.text, link.url, options)
        end

        while crumb = crumb.parent
          last_parent = crumb.name
          crumb = Crumbs.get_crumb(crumb.name, crumb.object)
          while link = crumb.links.pop
            links.unshift ViewLink.new(link.text, link.url, options)
          end
        end

        if options[:autoroot] && @_breadcrumb_name != :root && last_parent != :root
          crumb = Crumbs.get_crumb(:root)
          while link = crumb.links.pop
            links.unshift ViewLink.new(link.text, link.url, options)
          end
        end

        last_link = links.pop

        out = []
        while link = links.shift
          out << ViewLink.new(link.text, link.url, options)
        end

        if last_link
          out << ViewLink.new(last_link.text, last_link.url, options, true)
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
      
      last_link = links.pop
      
      out = []
      while link = links.shift
        if options[:use_microformats]
          out << content_tag(:div, link_to(content_tag(:span, link.text, :itemprop => "title"), link.url, link.options.merge(:itemprop => "url")), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
        else
          out << link_to(link.text, link.url)
        end
      end
      
      if last_link
        if options[:link_last] || options[:link_current]
          if options[:use_microformats]
            out << content_tag(:div, link_to(content_tag(:span, last_link.text, :class => "current", :itemprop => "title"), last_link.url, last_link.options.merge(:itemprop => "url")), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
          else
            out << link_to(last_link.text, last_link.url, :class => "current")
          end
        else
          if options[:use_microformats]
            out << content_tag(:div, content_tag(:span, last_link.text, :class => "current", :itemprop => "title"), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
          else
            out << content_tag(:span, last_link.text, :class => "current")
          end
        end
      end
      
      out.join(options[:separator] || " &gt; ").html_safe
    end
  end
end