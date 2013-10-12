Changelog
=========

Version 3.0
-----------
* Support for `Gretel::Crumbs.layout do ... end` in an initializer has been removed. See the readme for details on how to upgrade.
* Support for setting trails via the URL – `params[:trail]`. This makes it possible to link to a different breadcrumb trail than the one specified in your breadcrumb,
  for example if you have a store with products that have a default parent to their category, but when linking from the review section, you want to link back to the reviews instead.
  See the readme for more info.
* Breadcrumbs rendering is now done in a separate class to unclutter the view with helpers. The public API is still the same.
* The `:show_root_alone` option is now called `:display_single_fragment` and can be used to display the breadcrumbs only when there are more than one link, also if it is not the root breadcrumb.

Version 2.1
-----------
* Breadcrumbs are now configured in `config/breadcrumbs.rb` and `config/breadcrumbs/**/*.rb` and reloaded when changed in the development environment instead of the initializer that required restart when configuration changed.

Version 2.0
-----------

* Totally rewritten for better structure.
* `options[:autoroot]` is now `true` by default which means it will automatically link to the `:root` breadcrumb if no parent is specified.
* Now accepts `options[:class]` for specifying the CSS class for the breadcrumbs container. Default: `"breadcrumbs"`.
* Now accepts `options[:current_class]` for specifying the CSS class for the current link / span. Default: `"current"`.
* `options[:link_last]` was deprecated in a previous version and is now removed. Use `options[:link_current]` instead.
* The `link` method in `crumb :xx do ... end` no longer takes HTML options. The method for this is now by building the breadcrumbs manually (see the readme).
* No longer supports procs for link text or URL as this is unnecessary when you can pass arguments to the block anyway.
* It now accepts multiple arguments for `crumb` and `parent` (see the readme).
* Breadcrumbs are now rendered with `<%= breadcrumbs %>`, although you can still use the old `<%= breadcrumb %>` (without *s*).
* You can now access view helpers from inside `Gretel::Crumbs.layout do .. end`.