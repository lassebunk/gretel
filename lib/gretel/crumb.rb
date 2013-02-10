module Gretel
  class Crumb
    def initialize(key, *params)
      block = Gretel::Crumbs.crumbs[key]
      raise ArgumentError, "Breadcrumb :#{key} not found." unless block

      self.params = params
      instance_exec *params, &block
    end

    def link(text, url)
      links << Gretel::Link.new(text, url)
    end

    def links
      @links ||= []
    end

    def parent(*args)
      return @parent unless args.any?
      key, *params = args
      
      @parent ||= Gretel::Crumb.new(key, *params)
    end

    attr_accessor :params
  end
end