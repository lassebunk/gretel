module Gretel
  class Renderer
    DEFAULT_OPTIONS = {
      style: :inline,
      pretext: "",
      posttext: "",
      separator: "",
      autoroot: true,
      display_single_fragment: false,
      link_current: false,
      link_current_to_request_path: true,
      semantic: false,
      class: "breadcrumbs",
      current_class: "current",
      pretext_class: "pretext",
      posttext_class: "posttext",
      id: nil
    }

    DEFAULT_STYLES = {
      inline: { container_tag: :div, separator: " &rsaquo; " },
      ol: { container_tag: :ol, fragment_tag: :li },
      ul: { container_tag: :ul, fragment_tag: :li },
      bootstrap: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", current_class: "active" },
      bootstrap4: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", fragment_class: "breadcrumb-item", current_class: "active" },
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

    # Yields links with applied options.
    def yield_links(options = {})
      yield render(options)
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
      if options[:link_current_to_request_path] && out.any? && request
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
      #   Gretel::Renderer.register_style :ul, { container_tag: :ul, fragment_tag: :li }
      def register_style(style_key, options)
        styles[style_key] = options
      end

      # Hash of registered styles.
      def styles
        @styles ||= DEFAULT_STYLES
      end
    end

    class LinkCollection < Array
      attr_reader :context, :links, :options

      def initialize(context, links, options = {})
        @context, @links, @options = context, links, options
        concat links
      end

      # Helper for returning all link keys to allow for simple testing.
      def keys
        map(&:key)
      end

      # Renders the links into breadcrumbs.
      def render
        return "" if links.empty?

        # Loop through all but the last (current) link and build HTML of the fragments
        fragments = links[0..-2].map do |link|
          render_fragment(options[:fragment_tag], link.text, link.url, options[:semantic], fragment_class: options[:fragment_class])
        end

        # The current link is handled a little differently, and is only linked if specified in the options
        current_link = links.last
        fragments << render_fragment(options[:fragment_tag], current_link.text, (options[:link_current] ? current_link.url : nil), options[:semantic], fragment_class: options[:fragment_class], class: options[:current_class], current_link: current_link.url)

        # Build the final HTML
        html_fragments = []

        if options[:pretext].present?
          html_fragments << content_tag(:span, options[:pretext], class: options[:pretext_class])
        end

        html_fragments << fragments.join(options[:separator])

        if options[:posttext].present?
          html_fragments << content_tag(:span, options[:posttext], class: options[:posttext_class])
        end

        html = html_fragments.join(" ").html_safe
        content_tag(options[:container_tag], html, id: options[:id], class: options[:class])
      end

      alias :to_s :render

      # Renders HTML for a breadcrumb fragment, i.e. a breadcrumb link.
      def render_fragment(fragment_tag, text, url, semantic, options = {})
        if semantic
          render_semantic_fragment(fragment_tag, text, url, options)
        else
          render_nonsemantic_fragment(fragment_tag, text, url, options)
        end
      end

      # Renders semantic fragment HTML.
      def render_semantic_fragment(fragment_tag, text, url, options = {})
        fragment_class = [options[:fragment_class], options[:class]].join(' ').strip
        fragment_class = nil if fragment_class.blank?

        if fragment_tag
          text = content_tag(:span, text, itemprop: "title")

          if url.present?
            text = breadcrumb_link_to(text, url, itemprop: "url")
          elsif options[:current_link].present?
            current_url = "#{root_url}#{options[:current_link].gsub(/^\//, '')}"
            text = text + tag(:meta, itemprop: "url", content: current_url)
          end

          content_tag(fragment_tag, text, class: fragment_class, itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
        elsif url.present?
          content_tag(:span, breadcrumb_link_to(content_tag(:span, text, itemprop: "title"), url, class: fragment_class, itemprop: "url"), itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
        else
          content_tag(:span, content_tag(:span, text, class: fragment_class, itemprop: "title"), itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
        end
      end

      # Renders regular, non-semantic fragment HTML.
      def render_nonsemantic_fragment(fragment_tag, text, url, options = {})
        fragment_class = [options[:fragment_class], options[:class]].join(' ').strip
        fragment_class = nil if fragment_class.blank?

        if fragment_tag
          text = breadcrumb_link_to(text, url) if url.present?
          content_tag(fragment_tag, text, class: fragment_class)
        elsif url.present?
          breadcrumb_link_to(text, url, class: fragment_class)
        elsif options[:class].present?
          content_tag(:span, text, class: fragment_class)
        else
          text
        end
      end

      # Proxy for +context.link_to+ that can be overridden by plugins.
      def breadcrumb_link_to(name, url, options = {})
        context.link_to(name, url, options)
      end

      # Proxy to view context.
      def method_missing(method, *args, &block)
        context.send(method, *args, &block)
      end
    end
  end
end
