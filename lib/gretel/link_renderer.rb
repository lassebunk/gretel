module Gretel
  class LinkRenderer
    DEFAULT_OPTIONS = {
      style: :inline,
      pretext: "",
      posttext: "",
      separator: "",
      autoroot: true,
      display_single_fragment: false,
      link_current: false,
      link_last_to_current_path: true,
      semantic: false,
      class: "breadcrumbs",
      current_class: "current",
      id: nil
    }

    DEFAULT_STYLES = {
      inline: { container_tag: :div, separator: " &rsaquo; " },
      ol: { container_tag: :ol, fragment_tag: :li },
      ul: { container_tag: :ul, fragment_tag: :li },
      bootstrap: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", current_class: "active" },
      foundation5: { container_tag: :ul, fragment_tag: :li, class: "breadcrumbs", current_class: "current" }
    }

    def initialize(context, breadcrumb_key, *breadcrumb_args)
      @context = context
      @breadcrumb_key = breadcrumb_key
      @breadcrumb_args = breadcrumb_args
    end

    # Renders the breadcrumbs HTML.
    def render(options)
      options = options_for_render(options)
      links = links_for_render(options)

      LinkCollection.new(context, links, options)
    end

    # Returns the parent breadcrumb.
    def parent_breadcrumb(options = {})
      render(options)[-2]
    end

    # Yields the parent breadcrumb if any.
    def yield_parent_breadcrumb(options = {})
      if parent = parent_breadcrumb(options)
        yield parent
      end
    end

    private

    attr_reader :context, :breadcrumb_key, :breadcrumb_args

    # Returns merged options for rendering breadcrumbs.
    def options_for_render(options = {})
      style = options_for_style(options[:style] || DEFAULT_OPTIONS[:style])
      DEFAULT_OPTIONS.merge(style).merge(options)
    end

    # Returns options for the given +style_key+ and raises an exception if it's not found.
    def options_for_style(style_key)
      if style = self.class.styles[style_key]
        style
      else
        raise ArgumentError, "Breadcrumbs style #{style_key.inspect} not found. Use any of #{self.class.styles.keys.inspect}."
      end
    end

    # Array of links with applied options.
    def links_for_render(options = {})
      out = links.dup

      # Handle autoroot
      if options[:autoroot] && out.map(&:key).exclude?(:root) && Gretel::Crumbs.crumb_defined?(:root)
        out.unshift *Gretel::Crumb.new(context, :root).links
      end

      # Set current link to actual path
      if options[:link_last_to_current_path] && out.any? && request
        out.last.url = request.fullpath
      end

      # Handle show root alone
      if out.size == 1 && !options[:display_single_fragment]
        out.shift
      end

      # Set last link to current
      out.last.try(:current!)

      out
    end

    # Array of links for the path of the breadcrumb.
    # Also reloads the breadcrumb configuration if needed.
    def links
      @links ||= if @breadcrumb_key.present?
        # Reload breadcrumbs configuration if needed
        Gretel::Crumbs.reload_if_needed

        # Get breadcrumb set by the `breadcrumb` method
        crumb = Gretel::Crumb.new(context, breadcrumb_key, *breadcrumb_args)

        # Links of first crumb
        links = crumb.links.dup
        
        # Get parent links
        links.unshift *parent_links_for(crumb)

        links
      else
        []
      end
    end

    # Returns parent links for the crumb.
    def parent_links_for(crumb)
      links = []
      while crumb = crumb.parent
        links.unshift *crumb.links
      end
      links
    end

    # Proxy to view context.
    def method_missing(method, *args, &block)
      context.send(method, *args, &block)
    end

    class << self
      include Resettable
      
      # Registers a style for later use.
      # 
      #   Gretel::LinkRenderer.register_style :ul, { container_tag: :ul, fragment_tag: :li }
      def register_style(style_key, options)
        styles[style_key] = options
      end

      # Hash of registered styles.
      def styles
        @styles ||= DEFAULT_STYLES
      end
    end
  end
end
