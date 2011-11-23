ActionView::Helpers::TagHelper::BOOLEAN_ATTRIBUTES << :itemscope

module Gretel
  module HelperMethods
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
      link_options = options[:semantic] ? {
        :itemprop => 'title url'
      } : {}

      name, object = args[0], args[1]
      
      crumb = Crumbs.get_crumb(name, object)
      out = [self.class.helpers.link_to_if(link_last, crumb.link.text, crumb.link.url, crumb.link.options.reverse_merge(link_options))]
      
      while parent = crumb.parent
        last_parent = parent.name
        crumb = Crumbs.get_crumb(parent.name, parent.object)
        out.unshift(self.class.helpers.link_to(crumb.link.text, crumb.link.url, crumb.link.options.reverse_merge(link_options)))
      end
      
      # TODO: Refactor this
      if options[:autoroot] && name != :root && last_parent != :root
        crumb = Crumbs.get_crumb(:root)
        out.unshift(self.class.helpers.link_to(crumb.link.text, crumb.link.url, crumb.link.options.reverse_merge(link_options)))
      end
      
      out = out.map { |link| %Q{<span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">#{link}</span>} } if options[:semantic]
      out.join(" #{separator} ").html_safe
    end
  end
end