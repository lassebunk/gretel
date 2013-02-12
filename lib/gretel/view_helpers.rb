module Gretel
  module ViewHelpers
    # Sets the current breadcrumb to be rendered elsewhere. Put it somewhere in the view, preferably in the top, before you render any breadcrumbs HTML:
    #   <%
    #   breadcrumb :category, @category
    #   %>
    def breadcrumb(*args)
      options = args.extract_options!

      if args.any?
        @_breadcrumb_key = args.shift
        @_breadcrumb_args = args
      else
        breadcrumbs(options)
      end
    end

    # Renders the breadcrumbs HTML, for example in your layout. See the readme for default options.
    #   <%= breadcrumbs :pretext => "You are here: " %>
    #
    # If you supply a block, it will yield an array with the breadcrumb links so you can build the breadcrumbs HTML manually:
    #   <% breadcrumbs do |links| %>
    #     <% if links.any? %>
    #       You are here:
    #       <% links.each do |link| %>
    #         <%= link_to link.text, link.url %> (<%= link.key %>)
    #       <% end %>
    #     <% end %>
    #   <% end %>
    def breadcrumbs(options = {})
      options = default_breadcrumb_options.merge(options)
      links = get_breadcrumb_links(options)
      if block_given?
        yield links
      else
        render_breadcrumbs(links, options)
      end
    end

    # Returns an array of links for the path of the breadcrumb set by +breadcrumb+.
    def get_breadcrumb_links(options = {})
      return [] if @_breadcrumb_key.blank?

      # Get breadcrumb set by the `breadcrumb` method
      crumb = Gretel::Crumb.new(self, @_breadcrumb_key, *@_breadcrumb_args)

      # Links of first crumb
      links = crumb.links.dup

      # Build parents
      while crumb = crumb.parent
        links.unshift *crumb.links
      end

      # Handle autoroot
      if options[:autoroot] && links.map(&:key).exclude?(:root)
        links.unshift *Gretel::Crumb.new(self, :root).links
      end

      # Handle show root alone
      if links.count == 1 && links.first.key == :root && !options[:show_root_alone]
        links.shift
      end

      links
    end

    # Renders breadcrumbs HTML.
    def render_breadcrumbs(links, options)
      return "" if links.empty?

      # Array to hold the HTML fragments
      fragments = []

      # Loop through all but the last (current) link and build HTML of the fragments
      links[0..-2].each do |link|
        fragments << render_breadcrumb_fragment(link.text, link.url, options[:semantic])
      end

      # The current link is handled a little differently, and is only linked if specified in the options
      current_link = links.last
      fragments << render_breadcrumb_fragment(current_link.text, (options[:link_current] ? current_link.url : nil), options[:semantic], :class => options[:current_class])

      # Build the final HTML
      html = (options[:pretext] + fragments.join(options[:separator]) + options[:posttext]).html_safe
      content_tag(:div, html, :id => options[:id], :class => options[:class])
    end

    # Renders HTML for a breadcrumb fragment, i.e. a breadcrumb link.
    def render_breadcrumb_fragment(text, url, semantic, options = {})
      if semantic
        if url.present?
          content_tag(:div, link_to(content_tag(:span, text, :itemprop => "title"), url, :class => options[:class], :itemprop => "url"), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
        else
          content_tag(:div, content_tag(:span, text, :class => options[:class], :itemprop => "title"), :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
        end
      else
        if url.present?
          link_to(text, url, :class => options[:class])
        elsif options[:class]
          content_tag(:span, text, :class => options[:class])
        else
          text
        end
      end
    end

    # Default options for the breadcrumb rendering.
    def default_breadcrumb_options
      { :pretext => "",
        :posttext => "",
        :separator => " &gt; ",
        :autoroot => false,
        :show_root_alone => false,
        :link_current => false,
        :semantic => false,
        :class => "breadcrumbs",
        :current_class => "current",
        :id => nil }
    end
  end
end
