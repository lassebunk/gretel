if RUBY_VERSION < "2.0"
  Gretel::Renderer.class_eval do
    def options_for_style_with_default_style_key(style_key)
      if style_key == :default
        Gretel.show_deprecation_warning "The :default style key is now called :inline. Please use `breadcrumbs style: :inline` instead or omit it, as it is the default."
        style_key = :inline
      end
      options_for_style_without_default_style_key(style_key)
    end

    alias_method_chain :options_for_style, :default_style_key
  end
else
  module DeprecatedDefaultStyleKey
    def options_for_style(style_key)
      if style_key == :default
        Gretel.show_deprecation_warning "The :default style key is now called :inline. Please use `breadcrumbs style: :inline` instead or omit it, as it is the default."
        style_key = :inline
      end
      super(style_key)
    end
  end

  Gretel::Renderer.send :prepend, DeprecatedDefaultStyleKey
end