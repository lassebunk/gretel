module Gretel
  module Crumbs
    class << self
      # Lay out the breadcrumbs.
      # Deprecated since v2.1.0. Put breadcrumbs in +config/breadcrumbs.rb+ instead (see https://github.com/lassebunk/gretel/blob/master/README.md for details).
      #
      # Example:
      #   Gretel::Crumbs.layout do
      #     crumb :root do
      #       link "Home", root_path
      #     end
      #   end
      def layout(&block)
        Gretel.show_deprecation_warning(
          "Gretel::Crumbs.layout has been deprecated and will be removed in Gretel version 3.0. " +
          "Please put your breadcrumbs in `config/breadcrumbs.rb`. " +
          "This will also automatically reload your breadcrumbs when you change them in the development environment. " +
          "See https://github.com/lassebunk/gretel/blob/master/README.md for details.")
        @deprecated_breadcrumbs_block = block
      end

      def deprecated_breadcrumbs_block
        @deprecated_breadcrumbs_block ||= Proc.new {}
      end
    end
  end
end
