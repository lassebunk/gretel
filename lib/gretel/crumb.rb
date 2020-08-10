module Gretel
  class Crumb
    # Initializes a new crumb from the given +key+.
    # It finds the breadcrumb created in +Gretel::Crumbs.layout+ and renders the block using the arguments supplied in +args+.
    def initialize(context, key, *args)
      if key.class.respond_to?(:model_name)
        # Enables calling `breadcrumb @product` instead of `breadcrumb :product, @product`
        args.unshift key
        key = key.class.model_name.to_s.underscore.to_sym
      end

      block = Gretel::Crumbs.crumbs[key]
      raise ArgumentError, "Breadcrumb :#{key} not found." unless block
      @key = key
      @context = context
      instance_exec *args, &block
    end

    # Sets link of the breadcrumb.
    # You can supply an optional options hash that will be available on the links
    # so you can pass info when rendering the breadcrumbs manually.
    #
    #   link "My Link", my_link_path
    #   link "Without URL"
    #   link "With Options", my_path, title: "Test", other: "Some other value"
    def link(*args)
      options = args.extract_options!
      text, url = args

      # Transform objects to real paths.
      url = url_for(url) if url
      
      links << Gretel::Link.new(key, text, url, options)
    end

    # Holds all of the breadcrumb's links as a breadcrumb can have multiple links.
    def links
      @links ||= []
    end

    # Sets or gets the parent breadcrumb.
    # If you supply a parent key and optional arguments, it will set the parent.
    # If nothing is supplied, it will return the parent, if this has been set.
    #
    # Example:
    #   parent :category, category
    #
    # Or short, which will infer the key from the model's `model_name`:
    #   parent category
    def parent(*args)
      return @parent if args.empty?
      key = args.shift

      @parent = Gretel::Crumb.new(context, key, *args)
    end

    # Key of the breadcrumb.
    attr_reader :key

    # The current view context.
    attr_reader :context

    # Proxy to view context.
    def method_missing(method, *args, &block)
      context.send(method, *args, &block)
    end
  end
end
