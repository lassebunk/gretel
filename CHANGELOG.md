Changelog
=========

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