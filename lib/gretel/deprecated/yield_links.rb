if RUBY_VERSION < "2.0"
  Gretel::ViewHelpers.class_eval do

  def breadcrumbs_with_yield_links(options = {})
    if block_given?
      Gretel.show_deprecation_warning(
        "Calling `breadcrumbs` with a block has been deprecated and will be removed in Gretel version 4.0. Please use `tap` instead. Example:\n" +
        "\n" +
        "  breadcrumbs(autoroot: false).tap do |links|\n" +
        "    if links.any?\n" +
        "      # process links here\n" +
        "    end\n" +
        "  end\n"
      )
      yield gretel_renderer.render(options)
    else
      breadcrumbs_without_yield_links(options)
    end
  end

  alias_method_chain :breadcrumbs, :yield_links
  end
else
  module DeprecatedYieldLinks
    def breadcrumbs(options = {})
      if block_given?
        Gretel.show_deprecation_warning(
            "Calling `breadcrumbs` with a block has been deprecated and will be removed in Gretel version 4.0. Please use `tap` instead. Example:\n" +
                "\n" +
                "  breadcrumbs(autoroot: false).tap do |links|\n" +
                "    if links.any?\n" +
                "      # process links here\n" +
                "    end\n" +
                "  end\n"
        )
        yield gretel_renderer.render(options)
      else
        super(options)
      end
    end
  end

  Gretel::ViewHelpers.send :prepend, DeprecatedYieldLinks
end
