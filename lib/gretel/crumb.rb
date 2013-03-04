module Gretel
  class Crumb
    # Initializes a new crumb from the given +key+.
    # It finds the breadcrumb created in +Gretel::Crumbs.layout+ and renders the block using the arguments supplied in +args+.
    def initialize(context, key, *args)
      block = Gretel::Crumbs.crumbs[key]
      raise ArgumentError, "Breadcrumb :#{key} not found." unless block
      @key = key
      @context = context
      instance_exec *args, &block
    end

    # Sets link of the breadcrumb.
    def link(text, url = nil)
      links << Gretel::Link.new(key, text, url)
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
    def parent(*args)
      return @parent unless args.any?
      key = args.shift

      @parent = Gretel::Crumb.new(context, key, *args)
    end

    # Key of the breadcrumb.
    attr_reader :key

    # The current view context.
    attr_reader :context

    # Proxy to view context
    def method_missing(method, *args, &block)
      context.send(method, *args, &block)
    end
  end
end
