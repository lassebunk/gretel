module Gretel
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
        render_fragment(options[:fragment_tag], link.text, link.url, options[:semantic])
      end

      # The current link is handled a little differently, and is only linked if specified in the options
      current_link = links.last
      fragments << render_fragment(options[:fragment_tag], current_link.text, (options[:link_current] ? current_link.url : nil), options[:semantic], class: options[:current_class])

      # Build the final HTML
      html = (options[:pretext] + fragments.join(options[:separator]) + options[:posttext]).html_safe
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
      if fragment_tag
        text = content_tag(:span, text, itemprop: "title")
        text = breadcrumb_link_to(text, url, itemprop: "url") if url.present?
        content_tag(fragment_tag, text, class: options[:class], itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
      elsif url.present?
        content_tag(:div, breadcrumb_link_to(content_tag(:span, text, itemprop: "title"), url, class: options[:class], itemprop: "url"), itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
      else
        content_tag(:div, content_tag(:span, text, class: options[:class], itemprop: "title"), itemscope: "", itemtype: "http://data-vocabulary.org/Breadcrumb")
      end
    end

    # Renders regular, non-semantic fragment HTML.
    def render_nonsemantic_fragment(fragment_tag, text, url, options = {})
      if fragment_tag
        text = breadcrumb_link_to(text, url) if url.present?
        content_tag(fragment_tag, text, class: options[:class])
      elsif url.present?
        breadcrumb_link_to(text, url, class: options[:class])
      elsif options[:class].present?
        content_tag(:span, text, class: options[:class])
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