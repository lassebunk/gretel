module Gretel
  class Link
    attr_accessor :key, :text, :url, :options

    def initialize(key, text, url, options = {})
      # Use accessors so plugins can override their behavior
      self.key, self.text, self.url, self.options = key, text, url, options
    end

    # Sets current so +current?+ will return +true+.
    def current!
      @current = true
    end

    # Returns +true+ if this is the last link in the breadcrumb trail.
    def current?
      !!@current
    end

    # Enables accessors and predicate methods for values in the +options+ hash.
    # This can be used to pass information to links when rendering breadcrumbs
    # manually.
    #
    #   link = Link.new(:my_crumb, "My Crumb", my_path, title: "Test Title", other_value: "Other")
    #   link.title?       # => true
    #   link.title        # => "Test Title"
    #   link.other_value? # => true
    #   link.other_value  # => "Other"
    #   link.some_other?  # => false
    #   link.some_other   # => nil
    def method_missing(method, *args, &block)
      if method =~ /(.+)\?$/
        options[$1.to_sym].present?
      else
        options[method]
      end
    end
  end
end