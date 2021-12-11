require 'gretel/crumbs'
require 'gretel/crumb'

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
      link_class: nil,
      id: nil,
      aria_current: nil
    }

    DEFAULT_STYLES = {
      inline: { container_tag: :div, separator: " &rsaquo; " },
      ol: { container_tag: :ol, fragment_tag: :li },
      ul: { container_tag: :ul, fragment_tag: :li },
      bootstrap: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", current_class: "active" },
      bootstrap4: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", fragment_class: "breadcrumb-item", current_class: "active" },
      bootstrap5: { container_tag: :ol, fragment_tag: :li, class: "breadcrumb", fragment_class: "breadcrumb-item", current_class: "active" },
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

      # Returns a hash matching the JSON-LD Structured Data schema
      # https://developers.google.com/search/docs/data-types/breadcrumb#json-ld
      def structured_data(url_base:)
        url_base = url_base.chomp("/") # Remove trailing `/`, if present

        items = @links.each_with_index.map do |link, i|
          {
            "@type": "ListItem",
            "position": i + 1,
            "name": link.text,
            "item": "#{url_base}#{link.url}"
          }
        end

        {
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          "itemListElement": items
        }
      end

      # Helper for returning all link keys to allow for simple testing.
      def keys
        map(&:key)
      end

      # Renders the links into breadcrumbs.
      def render
        return "" if links.empty?

        renderer_class = options[:semantic] ? SemanticRenderer : NonSemanticRenderer
        renderer = renderer_class.new(context, options)
        # Loop through all but the last (current) link and build HTML of the fragments
        fragments = links[0..-2].map.with_index do |link, index|
          renderer.render_fragment(link, index + 1)
        end

        # The current link is handled a little differently, and is only linked if specified in the options
        current_link = links.last
        position = links.size
        fragments << renderer.render_current_fragment(current_link, position)

        # Build the final HTML
        html_fragments = [
          renderer.render_pretext,
          fragments.join(options[:separator]),
          renderer.render_posttext
        ]
        html = html_fragments.compact.join(" ").html_safe
        renderer.render_container(html)
      end

      alias :to_s :render

      # Avoid unnecessary html escaping by template engines.
      def html_safe?
        true
      end
    end

    class Base
      attr_reader :context, :options

      def initialize(context, options)
        @context = context
        @options = options
      end

      def render_fragment(link, position)
        render_fragment_tag(fragment_tag, link.text, link.url, position, **fragment_options)
      end

      def render_current_fragment(link, position)
        url = options[:link_current] ? link.url : nil
        opts = fragment_options.merge(class: options[:current_class], current_link: link.url, aria_current: options[:aria_current])
        render_fragment_tag(fragment_tag, link.text, url, position, **opts)
      end

      def render_fragment_tag(fragment_tag, text, url, position, options = {})
      end

      def render_container(html)
      end

      def render_pretext
        if options[:pretext].present?
          content_tag(:span, options[:pretext], class: options[:pretext_class])
        end
      end

      def render_posttext
        if options[:posttext].present?
          content_tag(:span, options[:posttext], class: options[:posttext_class])
        end
      end

      private

      def fragment_tag
        options[:fragment_tag]
      end

      def fragment_options
        options.slice(:fragment_class, :link_class)
      end

      def join_classes(*classes)
        clazz = classes.join(' ').strip
        clazz.blank? ? nil : clazz
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

    class NonSemanticRenderer < Base
      def render_fragment_tag(fragment_tag, text, url, position, options = {})
        fragment_class = join_classes(options[:fragment_class], options[:class])

        if fragment_tag
          if url.present?
            text = breadcrumb_link_to(text, url, "aria-current": options[:aria_current])
            content_tag(fragment_tag, text, class: fragment_class)
          else
            content_tag(fragment_tag, text, class: fragment_class, "aria-current": options[:aria_current])
          end
        elsif url.present?
          breadcrumb_link_to(text, url, class: join_classes(fragment_class, options[:link_class]), "aria-current": options[:aria_current])
        elsif options[:class].present?
          content_tag(:span, text, class: fragment_class, "aria-current": options[:aria_current])
        else
          text
        end
      end

      def render_container(html)
        content_tag(options[:container_tag], html, id: options[:id], class: options[:class])
      end
    end

    class SemanticRenderer < Base
      def render_fragment_tag(fragment_tag, text, url, position, options = {})
        fragment_class = join_classes(options[:fragment_class], options[:class])
        fragment_tag = fragment_tag || 'span'
        text = content_tag(:span, text, itemprop: "name")

        aria_current = options[:aria_current]
        if url.present?
          text = breadcrumb_link_to(text, url, itemprop: "item", "aria-current": aria_current, class: options[:link_class])
          aria_current = nil
        elsif options[:current_link].present?
          current_url = "#{root_url}#{options[:current_link].gsub(/^\//, '')}"
          text = text + tag(:meta, itemprop: "item", content: current_url)
        end

        text = text + tag(:meta, itemprop:"position", content: "#{position}")
        content_tag(fragment_tag.to_sym, text, class: fragment_class, itemprop: "itemListElement", itemscope: "", itemtype: "https://schema.org/ListItem", "aria-current": aria_current)
      end

      def render_container(html)
        content_tag(options[:container_tag], html, id: options[:id], class: options[:class], itemscope: "", itemtype: "https://schema.org/BreadcrumbList")
      end
    end
  end
end
