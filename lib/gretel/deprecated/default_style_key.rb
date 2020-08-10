module DeprecatedDefaultStyleKey
  def options_for_style(style_key)
    if style_key == :default
      Gretel.show_deprecation_warning "The :default style key is now called :inline. Please use `breadcrumbs style: :inline` instead or omit it, as it is the default."
      style_key = :inline
    end
    super(style_key)
  end
end

Gretel::Renderer.prepend DeprecatedDefaultStyleKey
