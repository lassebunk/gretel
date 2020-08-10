if RUBY_VERSION < "2.0"
  Gretel::Renderer.class_eval do
    def options_for_render_with_show_root_alone(options = {})
      options = options_for_render_without_show_root_alone(options)
      if show_root_alone = options.delete(:show_root_alone)
        Gretel.show_deprecation_warning "The :show_root_alone option is deprecated and will be removed in Gretel v4.0.0. Use `breadcrumbs(display_single_fragment: #{show_root_alone.inspect})` instead."
        options[:display_single_fragment] = show_root_alone
      end
      options
    end

    alias_method_chain :options_for_render, :show_root_alone
  end
else
  module DeprecatedShowRootAlone
    def options_for_render(options = {})
      options = super(options)
      if show_root_alone = options.delete(:show_root_alone)
        Gretel.show_deprecation_warning "The :show_root_alone option is deprecated and will be removed in Gretel v4.0.0. Use `breadcrumbs(display_single_fragment: #{show_root_alone.inspect})` instead."
        options[:display_single_fragment] = show_root_alone
      end
      options
    end
  end

  Gretel::Renderer.send :prepend, DeprecatedShowRootAlone
end
