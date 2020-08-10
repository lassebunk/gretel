Gretel::Crumbs.class_eval do
  class << self
    # Was used to lay out breadcrumbs in an initializer. Deprecated since v2.1.0
    # and removed in v3.0.0. Will raise an exception if used. Put breadcrumbs in
    # +config/breadcrumbs.rb+ instead (see
    # https://github.com/lassebunk/gretel/blob/master/README.md for details).
    def layout(&block)
      raise (
        "Gretel::Crumbs.layout was removed in Gretel version 3.0. " +
        "Please put your breadcrumbs in `config/breadcrumbs.rb`. " +
        "This will also automatically reload your breadcrumbs when you change them in the development environment. " +
        "See https://github.com/lassebunk/gretel/blob/master/README.md for details.")
    end
  end
end