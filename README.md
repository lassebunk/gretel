[![Build Status](https://secure.travis-ci.org/lassebunk/gretel.png)](http://travis-ci.org/lassebunk/gretel)

Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.


Installation
------------

In your *Gemfile*:

```ruby
gem 'gretel', '2.0.0.beta1'
```

Or, if you want to run the stable version ([see documentation](https://github.com/lassebunk/gretel/tree/v1.2.1)):

```ruby
gem 'gretel', '1.2.1'
```

And run:

```bash
$ bundle install
```

Example
-------

Start by generating an initializer:

```bash
$ rails generate gretel:install
```

Then, in *config/initializers/breadcrumbs.rb*:

```ruby
Gretel::Crumbs.layout do
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

More examples
-------------

In *config/initializers/breadcrumbs.rb*:

```ruby
Gretel::Crumbs.layout do
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
end
```

Access to view helpers
----------------------

When inside `Gretel::Crumbs.layout do .. end`, you have access to all view helpers of the current view where the breadcrumbs are inserted.

Documentation
-------------

* [Full documentation](http://rubydoc.info/gems/gretel)
* [Changelog](https://github.com/lassebunk/gretel/blob/master/CHANGELOG.md)

Contributors
------------

* [See the list of contributors](https://github.com/lassebunk/gretel/graphs/contributors)

Copyright (c) 2010-2013 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
