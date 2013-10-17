[![Build Status](https://secure.travis-ci.org/lassebunk/gretel.png)](http://travis-ci.org/lassebunk/gretel)

Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.
It is based around the idea that breadcrumbs are a separate concern, and therefore should be defined in their own place.
You define a set of breadcrumbs in the config folder and specify in the view which breadcrumb to use.
Gretel also supports [semantic breadcrumbs](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=185417) (those used in Google results).

Have fun! And please do write, if you (dis)like it – [lassebunk@gmail.com](mailto:lassebunk@gmail.com).

New in version 3.0 :muscle:
---------------------------

* You can now set trails via the URL – `params[:trail]`. This makes it possible to link back to a different breadcrumb trail than the one specified in your breadcrumb,
  for example if you have a store with products that have a default parent to their category, but when visiting from the reviews section, you want to link back to the reviews instead.
  Read more about trails below.
* Breadcrumbs can now be rendered in different styles like ul- and ol lists, and for use with the [Twitter Bootstrap](http://getbootstrap.com/) framework. See the `:style` option below for more info.
* Defining breadcrumbs using `Gretel::Crumbs.layout do ... end` in an initializer has been removed. See below for details on how to upgrade.
* The `:show_root_alone` option is now called `:display_single_fragment` and can be used to hide the breadcrumbs when there is only one link, also if it is not the root breadcrumb.
  The old `:show_root_alone` option is still supported until Gretel version 4.0 and will show a deprecation warning when it's used.

I hope you find these changes as useful as I did when I made them – if you have more suggestions, please create an [Issue](https://github.com/lassebunk/gretel/issues) or [Pull Request](https://github.com/lassebunk/gretel/pulls).

See below for more info or the [changelog](https://github.com/lassebunk/gretel/blob/master/CHANGELOG.md) for less significant changes.

Installation
------------

In your *Gemfile*:

```ruby
gem "gretel", "3.0.0.beta3"
```

And run:

```bash
$ bundle install
```

Example
-------

Start by generating breadcrumbs configuration file:

```bash
$ rails generate gretel:install
```

Then, in *config/breadcrumbs.rb*:

```ruby
# Root crumb
crumb :root do
  link "Home", root_path
end

# Issue list
crumb :issues do
  link "All issues", issues_path
end

# Issue
crumb :issue do |issue|
  link issue.title, issue
  parent :issues
end
```

At the top of *app/views/issues/show.html.erb*, set the current breadcrumb (assuming you have loaded `@issue` with an issue):

```erb
<% breadcrumb :issue, @issue %>
```

Then, in *app/views/layouts/application.html.erb*:

```erb
<%= breadcrumbs pretext: "You are here: ",
                separator: " &rsaquo; " %>
```

This will generate the following HTML (indented for readability):

```html
<div class="breadcrumbs">
  You are here:
  <a href="/">Home</a> &rsaquo;
  <a href="/issues">All issues</a> &rsaquo;
  <span class="current">My Issue</span>
</div>
```

Options
-------

You can pass options to `<%= breadcrumbs %>`, e.g. `<%= breadcrumbs pretext: "You are here: " %>`:

Option                   | Description                                                                                                                | Default
------------------------ | -------------------------------------------------------------------------------------------------------------------------- | -------
:style                   | How to render the breadcrumbs. Can be `:default`, `:ol`, `:ul`, or `:bootstrap`. See below for more info.                  | `:default`
:pretext                 | Text to be rendered before breadcrumb, e.g. `"You are here: "`.                                                            | None
:posttext                | Text to be appended after breadcrumb, e.g. `"Text after breacrumb"`,                                                       | None
:separator               | Separator between links, e.g. `" &rsaquo; "`.                                                                              | `" &rsaquo; "`
:autoroot                | Whether it should automatically link to the `:root` crumb if no parent is given.                                           | True
:display_single_fragment | Whether it should display the breadcrumb if it includes only one link.                                                     | False
:link_current            | Whether the current crumb should be linked to.                                                                             | False
:semantic                | Whether it should generate [semantic breadcrumbs](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=185417). | False
:id                      | ID for the breadcrumbs container.                                                                                          | None
:class                   | CSS class for the breadcrumbs container.                                                                                   | `"breadcrumbs"`
:current_class           | CSS class for the current link or span.                                                                                    | `"current"`
:container_tag           | Tag type that contains the breadcrumbs.                                                                                    | `:div`
:fragment_tag            | Tag type to contain each breadcrumb fragment/link.                                                                         | None

### Styles

These are the styles you can use with `breadcrumb style: :xx`.

Style        | Description
------------ | -----------
`:default`   | Renders each link by itself with `&rsaquo;` as the seperator.
`:ol`        | Renders the links in `<li>` elements contained in an outer `<ol>`.
`:ul`        | Renders the links in `<li>` elements contained in an outer `<ul>`.
`:bootstrap` | Renders the links for use in [Twitter Bootstrap](http://getbootstrap.com/).

Or you can build the breadcrumbs manually for full customization; see below.

If you add other widely used styles, please submit a [Pull Request](https://github.com/lassebunk/gretel/pulls) so others can use them too.

More examples
-------------

In *config/breadcrumbs.rb*:

```ruby
# Root crumb
crumb :root do
  link "Home", root_path
end

# Regular crumb
crumb :projects do
  link "Projects", projects_path
end

# Parent crumbs
crumb :project_issues do |project|
  link "Issues", project_issues_path(project)
  parent :project, project
end

# Child 
crumb :issue do |issue|
  link issue.name, issue_path(issue)
  parent :project_issues, issue.project
end

# Multiple links per crumb (recursive links for parent categories)
crumb :category do |category|
  parents = [category]

  parent_category = category
  while parent_category = parent_category.parent_category
    parents.unshift parent_category
  end

  parents.each do |category|
    link category.name, category
  end

  parent :categories
end

# Product crumb with recursive parent categories
crumb :product do |product|
  link product.name, product
  parent :category, product.category
end

# Example of using params to alter the parent, e.g. to
# match the user's actual navigation path
# URL: /products/123?q=my+search
crumb :search do |keyword|
  link "Search for #{keyword}", search_path(q: keyword)
end

crumb :product do |product|
  if keyword = params[:q].presence
    parent :search, keyword
  else # default
    parent :category, product.category
  end
end

# Multiple arguments
crumb :multiple_test do |a, b, c|
  link "Test #{a}, #{b}, #{c}", test_path
  parent :other_test, 3, 4, 5
end

# Breadcrumb without link URL; will not generate a link
crumb :without_link do
  link "Breadcrumb without link"
end

# Breadcrumb using view helper
module UsersHelper
  def user_name_for(user)
    user.name
  end
end

crumb :user do |user|
  link user_name_for(user), user
end
```

Building the breadcrumbs manually
---------------------------------

If you supply a block to the `breadcrumbs` method, it will yield an array with the breadcrumb links so you can build the breadcrumbs HTML manually:

```erb
<% breadcrumbs do |links| %>
  <% if links.any? %>
    You are here:
    <% links.each do |link| %>
      <%= link_to link.text, link.url, class: (link.current? ? "current" : nil) %> (<%= link.key %>)
    <% end %>
  <% end %>
<% end %>
```

Setting breadcrumb trails
--------------------------------

You can set a breadcrumb trail via `params[:trail]`. This makes it possible to link back to a different breadcrumb trail than the one specified in your breadcrumb.

An example is if you have a store with products that have a default parent to their category, but when visiting from the reviews section, you want to link back to the reviews instead.

### Initial setup

To use breadcrumb trails, you must set a secret to be used when encoding the trails.

You can generate it using the installer:

```bash
$ rails generate gretel:install
```

This will create an initializer in *config/initializers/gretel.rb* that will contain a random secret key.

If you want to do it manually, you can put the following in *config/initializers/gretel.rb*:

```
Gretel::Trail::UrlStore.secret = 'your_key_here' # Must be changed to something else to be secure
```

You can generate a key using `SecureRandom.hex(64)`.

### Example

This example shows how to link to the trail in the view.
Gretel has a built-in view helper method named `breadcrumb_trail` that contains the current breadcrumb trail ready for use in a URL.

```erb
<% breadcrumb :reviews %>
...
<% @products.each do |product| %>
  <%= link_to @product.name, product_path(product, trail: breadcrumb_trail) %>
<% end %>
```

The product view will now have the breadcrumb trail from the first page (reviews) instead of its default parent.

### Custom trail param

The default trail param is `params[:trail]`. You can change it in an initializer:

```ruby
Gretel::Trail.trail_param = :other_param
```

### Note

Please use the trail functionality with care; the trails can get very long.

Nice to know
------------

### Access to view methods

When configuring breadcrumbs inside a `crumb :xx do ... end` block, you have access to all methods that are normally accessible in the view where the breadcrumbs are inserted. This includes your view helpers, `params`, `request`, etc.

### Using multiple breadcrumb configuration files

If you have a large site and you want to split your breadcrumbs configuration over multiple files, you can create a folder named `config/breadcrumbs` and put your configuration files (e.g. `products.rb` or `frontend.rb`) in there.
The format is the same as `config/breadcrumbs.rb` which is also loaded.

### Automatic reloading of breadcrumb configuration files

Since Gretel version 2.1.0, the breadcrumb configuration files are now reloaded in the Rails development environment if they change. In other environments, like production, the files are loaded once, when first needed.

Upgrading from version 2.0 or below
-----------------------------------

Instead of using the initializer that in Gretel version 2.0 and below required restarting the application after breadcrumb configuration changes, the configuration of the breadcrumbs is now loaded from `config/breadcrumbs.rb` (and `config/breadcrumbs/*.rb` if you want to split your breadcrumbs configuration across multiple files).
In the Rails development environment, these files are automatically reloaded when changed.

Using the initializer (e.g. `config/initializers/breadcrumbs.rb`) was deprecated in Gretel version 2.1.0 and removed in version 3.0. It raises an error if you try to use it.

To update to the latest version of Gretel, use `bundle update gretel`. Then remove the `Gretel::Crumbs.layout do ... end` block, so instead of:

```ruby
Gretel::Crumbs.layout do
  crumb :root do
    link "Home", root_path
  end
end
```

in the initializer, you write:

```ruby
crumb :root do
  link "Home", root_path
end
```

in `config/breadcrumbs.rb`.

Documentation
-------------

* [Full documentation](http://rubydoc.info/gems/gretel)
* [Changelog](https://github.com/lassebunk/gretel/blob/master/CHANGELOG.md)

Versioning
----------

Follows [semantic versioning](http://semver.org/).

Contributors
------------

* [See the list of contributors](https://github.com/lassebunk/gretel/graphs/contributors)

Copyright (c) 2010-2013 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
