[![Build Status](https://secure.travis-ci.org/lassebunk/gretel.png)](http://travis-ci.org/lassebunk/gretel)

Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.

New in version 2.1
------------------
Instead of using the initializer that in Gretel version 2.0 and below required restarting the application after breadcrumb configuration changes, the configuration of the breadcrumbs is now loaded from `config/breadcrumbs.rb` (and `config/breadcrumbs/*.rb` if you want to split your breadcrumbs configuration across multiple files).
In the Rails development environment, these files are automatically reloaded when changed.

Using the initializer (e.g. `config/initializers/breadcrumbs.rb`) is deprecated but still supported until version 3.0.

Installation
------------

In your *Gemfile*:

```ruby
gem 'gretel'
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
<%= breadcrumbs :pretext => "You are here: ",
                :separator => " &rsaquo; " %>
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

You can pass options to `<%= breadcrumbs %>`, e.g. `<%= breadcrumbs :pretext => "You are here: " %>`:

Option           | Description                                                                                                                | Default
---------------- | -------------------------------------------------------------------------------------------------------------------------- | -------
:pretext         | Text to be rendered before breadcrumb, e.g. `"You are here: "`                                                             | None
:posttext        | Text to be appended after breadcrumb, e.g. `"Text after breacrumb"`                                                        | None
:separator       | Separator between links, e.g. `" &rsaquo; "`                                                                               | `" &gt; "`
:autoroot        | Whether it should automatically link to the `:root` crumb if no parent is given.                                           | True
:show_root_alone | Whether it should show `:root` if that is the only link.                                                                   | False
:link_current    | Whether the current crumb should be linked to.                                                                             | False
:semantic        | Whether it should generate [semantic breadcrumbs](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=185417). | False
:id              | ID for the breadcrumbs container.                                                                                          | None
:class           | CSS class for the breadcrumbs container.                                                                                   | `"breadcrumbs"`
:current_class   | CSS class for the current link or span.                                                                                    | `"current"`

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
  link "Search for #{keyword}", search_path(:q => keyword)
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
      <%= link_to link.text, link.url %> (<%= link.key %>)
    <% end %>
  <% end %>
<% end %>
```

Nice to know
------------

### Access to view helpers

When inside `Gretel::Crumbs.layout do .. end`, you have access to all view helpers of the current view where the breadcrumbs are inserted.

### Using multiple breadcrumb configuration files

If you have a large site and you want to split your breadcrumbs configuration over multiple files, you can create a folder named `config/breadcrumbs` and put your configuration files (e.g. `products.rb` or `frontend.rb`) in there.
The format is the same as `config/breadcrumbs.rb` which is also loaded.

### Automatic reloading of breadcrumb configuration files

Since Gretel version 2.1.0, the breadcrumb configuration files are now reloaded in the Rails development environment if they change. In other environments, like production, the files are loaded once, when first needed.

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
