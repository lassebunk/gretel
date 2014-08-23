module Gretel
  module ViewHelpers
    # Sets the current breadcrumb to be rendered elsewhere. Put it somewhere in the view, preferably in the top, before you render any breadcrumbs HTML:
    # 
    #   <% breadcrumb :category, @category %>
    # 
    # If you pass an instance of an object that responds to +model_name+ (like an ActiveRecord model instance), the breadcrumb can be automatically inferred, so a shortcut for the above would be:
    # 
    #   <% breadcrumb @category %>
    def breadcrumb(key = nil, *args)
      if key.nil? || key.is_a?(Hash)
        raise ArgumentError, "The `breadcrumb` method was called with #{key.inspect} as the key. This method is used to set the breadcrumb. Maybe you meant to call the `breadcrumbs` method (with an 's' in the end) which is used to render the breadcrumbs?"
      end
      @_gretel_renderer = Gretel::Renderer.new(self, key, *args)
    end

    # Yields a block where inside the block you have a different breadcrumb than outside.
    # 
    #   <% breadcrumb :about %>
    # 
    #   <%= breadcrumbs # shows the :about breadcrumb %>
    # 
    #   <% with_breadcrumb :product, Product.first do %>
    #     <%= breadcrumbs # shows the :product breadcrumb %>
    #   <% end %>
    # 
    #   <%= breadcrumbs # shows the :about breadcrumb %>
    def with_breadcrumb(key, *args, &block)
      original_renderer = @_gretel_renderer
      @_gretel_renderer = Gretel::Renderer.new(self, key, *args)
      yield
      @_gretel_renderer = original_renderer
    end

    # Renders the breadcrumbs HTML, for example in your layout. See the readme for default options.
    #   <%= breadcrumbs pretext: "You are here: " %>
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
      gretel_renderer.render(options)
    end

    # Returns or yields parent breadcrumb (second-to-last in the trail) if it is present.
    # 
    #   <% parent_breadcrumb do |link| %>
    #     <%= link_to link.text, link.url %> (<%= link.key %>)
    #   <% end %>
    def parent_breadcrumb(options = {}, &block)
      if block_given?
        gretel_renderer.yield_parent_breadcrumb(options, &block)
      else
        gretel_renderer.parent_breadcrumb(options)
      end
    end

    private

    # Reference to the Gretel breadcrumbs renderer.
    def gretel_renderer
      @_gretel_renderer ||= Gretel::Renderer.new(self, nil)
    end
  end
end
