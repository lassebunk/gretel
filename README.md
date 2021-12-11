[![Gem Version](https://badge.fury.io/rb/gretel.svg)](http://badge.fury.io/rb/gretel)
![](https://github.com/kzkn/gretel/workflows/CI/badge.svg)

<img src="http://i.imgur.com/CAKEaBM.png" alt="Handle breadcrumb trails... like a boss :)" />

([TL;DR](http://i.imgur.com/nH25yiH.png)) Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.
It is based around the idea that breadcrumbs are a concern of the view, so you define a set of breadcrumbs in *config/breadcrumbs.rb* (or multiple files; see below) and specify in the view which breadcrumb to use.
Gretel also supports [semantic breadcrumbs](https://developers.google.com/search/docs/data-types/breadcrumb) (those used in Google results).

Have fun!

## Installation

In your *Gemfile*:

```ruby
gem "gretel"
```

And run:

```bash
$ bundle install
```

## Example

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
  <span class="pretext">You are here:</span>
  <a href="/">Home</a> &rsaquo;
  <a href="/issues">All issues</a> &rsaquo;
  <span class="current">My Issue</span>
</div>
```

## Options

You can pass options to `<%= breadcrumbs %>`, e.g. `<%= breadcrumbs pretext: "You are here: " %>`:

Option                   | Description                                                                                                                | Default
------------------------ | -------------------------------------------------------------------------------------------------------------------------- | -------
:style                   | How to render the breadcrumbs. Can be `:inline`, `:ol`, `:ul`, or `:bootstrap`. See below for more info.                   | `:inline`
:pretext                 | Text to be rendered before breadcrumb, e.g. `"You are here: "`.                                                            | None
:posttext                | Text to be appended after breadcrumb, e.g. `"Text after breacrumb"`,                                                       | None
:separator               | Separator between links, e.g. `" &rsaquo; "`.                                                                              | `" &rsaquo; "`
:autoroot                | Whether it should automatically link to the `:root` crumb if no parent is given.                                           | True
:display_single_fragment | Whether it should display the breadcrumb if it includes only one link.                                                     | False
:link_current            | Whether the current crumb should be linked to.                                                                             | False
:link_current_to_request_path            | Whether the current crumb should always link to the current request path. *Note:* This option will have no effect unless `:link_current` is set to `true`.                                                                             | True
:semantic                | Whether it should generate [semantic breadcrumbs](https://developers.google.com/search/docs/data-types/breadcrumb). | False
:id                      | ID for the breadcrumbs container.                                                                                          | None
:class                   | CSS class for the breadcrumbs container. Can be set to `nil` for no class.                                                 | `"breadcrumbs"`
:fragment_class          | CSS class for the fragment link or span. Can be set to `nil` for no class.                                                 | None
:current_class           | CSS class for the current link or span. Can be set to `nil` for no class.                                                  | `"current"`
:pretext_class           | CSS class for the pretext, if given. Can be set to `nil` for no class.                                                     | `"pretext"`
:posttext_class          | CSS class for the posttext, if given. Can be set to `nil` for no class.                                                    | `"posttext"`
:link_class              | CSS class for the link, if given. Can be set to `nil` for no class.                                                        | None
:container_tag           | Tag type that contains the breadcrumbs.                                                                                    | `:div`
:fragment_tag            | Tag type to contain each breadcrumb fragment/link.                                                                         | None
:aria_current            | Value of `aria-current` attribute.                                                                                         | None

### Styles

These are the styles you can use with `breadcrumbs style: :xx`.

Style          | Description
-------------- | -----------
`:inline`      | Default. Renders each link by itself with `&rsaquo;` as the seperator.
`:ol`          | Renders the links in `<li>` elements contained in an outer `<ol>`.
`:ul`          | Renders the links in `<li>` elements contained in an outer `<ul>`.
`:bootstrap`   | Renders the links for use in [Bootstrap v3](https://getbootstrap.com/docs/3.4/).
`:bootstrap4`  | Renders the links for use in [Bootstrap v4](https://getbootstrap.com/docs/4.6/getting-started/introduction/).
`:bootstrap5`  | Renders the links for use in [Bootstrap v5](https://getbootstrap.com/).
`:foundation5` | Renders the links for use in [Foundation 5](https://get.foundation/).

Or you can build the breadcrumbs manually for full customization; see below.

If you add other widely used styles, please submit a [Pull Request](https://github.com/kzkn/gretel/pulls) so others can use them too.

## More examples

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
  parent project # inferred to :project
end

# Child
crumb :issue do |issue|
  link issue.name, issue_path(issue)
  parent :project_issues, issue.project
end

# Recursive parent categories
crumb :category do |category|
  link category.name, category
  if category.parent
    parent category.parent # inferred to :category
  else
    parent :categories
  end
end

# Product crumb with recursive parent categories (as defined above)
crumb :product do |product|
  link product.name, product
  parent product.category # inferred to :category
end

# Crumb with multiple links
crumb :test do
  link "One", one_path
  link "Two", two_path
  parent :about
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
    parent product.category # inferred to :category
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

# I18n
crumb :home do
  link t("breadcrumbs.home"), root_path
end
```

## Building the breadcrumbs manually

You can use the `breadcrumbs` method directly as an array. It will return an array with the breadcrumb links so you can build the breadcrumbs HTML manually:

```erb
<% breadcrumbs.tap do |links| %>
  <% if links.any? %>
    You are here:
    <% links.each do |link| %>
      <%= link_to link.text, link.url, class: (link.current? ? "current" : nil) %> (<%= link.key %>)
    <% end %>
  <% end %>
<% end %>
```

If you use this approach, you lose the built-in semantic breadcrumb functionality. One way to
add them back is to use JSON-LD structured data:

```erb
<script type="application/ld+json">
  <%= breadcrumbs.structured_data(url_base: "https://example.com") %>
</script>
```

Or, you can infer `url_base` from `request`:

```erb
<script type="application/ld+json">
  <%= breadcrumbs.structured_data(url_base: "#{request.protocol}#{request.host_with_port}") %>
</script>
```

## Getting the parent breadcrumb

If you want to add a link to the parent breadcrumb, you can use the `parent_breadcrumb` view helper.
By default it returns a link instance that has the properties `#key`, `#text`, and `#url`.
You can supply options like `autoroot: false` etc.

If you supply a block, it will yield the link if it is present:

```erb
<% parent_breadcrumb do |link| %>
  <%= link_to "Back to #{link.text}", link.url %>
<% end %>
```

## Nice to know

### Access to view methods

When configuring breadcrumbs inside a `crumb :xx do ... end` block, you have access to all methods that are normally accessible in the view where the breadcrumbs are inserted. This includes your view helpers, `params`, `request`, etc.

### Using multiple breadcrumb configuration files

If you have a large site and you want to split your breadcrumbs configuration over multiple files, you can create a folder named `config/breadcrumbs` and put your configuration files (e.g. `products.rb` or `frontend.rb`) in there.
The format is the same as `config/breadcrumbs.rb` which is also loaded.

### Loading breadcrumbs from engines

Breadcrumbs are automatically loaded from any engines' `config/breadcrumbs.rb` and `config/breadcrumbs/**/*.rb`.
Breadcrumbs defined in your main app will override breadcrumbs from engines.

### Inferring breadcrumbs

Breadcrumbs can be automatically inferred if you pass an instance of an object that responds to `model_name` (like an ActiveRecord model instance).

For example:

```erb
<% breadcrumb @product %>
```

is short for

```erb
<% breadcrumb :product, @product %>
```

### Passing options to links

You can pass options to links to be used when you render breadcrumbs manually.

In *config/breadcrumbs.rb*:

```ruby
crumb :something do
  link "My Link", my_path, title: "My Title", other: "My Other Option"
end
```

Example methods you can then use in the view:

```ruby
breadcrumbs do |links|
  links.each do |link|
    link.title?              # => true
    link.title               # => "My Title"
    link.other?              # => true
    link.other               # => "My Other Option"
    link.nonexisting_option? # => false
    link.nonexisting_option  # => nil
  end
end
```

### ARIA support

You can improve the accessibility of your page with the markup that specified in [ARIA](https://www.w3.org/TR/wai-aria-practices/examples/breadcrumb/index.html). Gretel supports generating `aria-current` attribute:

```erb
<% breadcrumb :issue, @issue %>
<%= breadcrumbs aria_current: "page" %>
```

This will generate the following HTML (indented for readability):

```html
<div class="breadcrumbs">
  <a href="/">Home</a> &rsaquo;
  <a href="/issues">All issues</a> &rsaquo;
  <span class="current" aria-current="page">My Issue</span>
</div>
```

## Documentation

* [Full documentation](https://rubydoc.info/gems/gretel)
* [Changelog](https://github.com/kzkn/gretel/blob/master/CHANGELOG.md)
* [Tutorial on using Gretel](https://www.sitepoint.com/breadcrumbs-rails-gretel/) (Sitepoint)

## Versioning

Follows [semantic versioning](https://semver.org/).

## Contributing

You are very welcome to help improve Gretel if you have suggestions for features that other people can use.

To contribute:

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes
4. Add/Fix tests
5. Prepare database for testing: `cd spec/dummy; rake db:migrate; rake db:test:prepare; cd ../..`
6. Run `rake` to make sure all tests pass
7. Be sure to check in the changes to `coverage/coverage.txt`
8. Commit your changes (`git commit -am 'Add new feature'`)
9. Push to the branch (`git push origin my-new-feature`)
10. Create new pull request

Thanks.

## Contributors

Gretel was created by [@lassebunk](https://github.com/lassebunk) and was maintained by [@WilHall](https://github.com/WilHall).
And it is maintained by [@kzkn](https://github.com/kzkn).

[See the list of contributors](https://github.com/kzkn/gretel/graphs/contributors)

## And then

<img src="http://i.imgur.com/u4Wbt4n.png" alt="After using Gretel, you'll be like this" />

Have fun!

Copyright (c) 2010-2020 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
