[![Build Status](https://secure.travis-ci.org/lassebunk/gretel.png)](http://travis-ci.org/lassebunk/gretel)

Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.


Installation
------------

In your *Gemfile*:

```ruby
gem 'gretel', '2.0.0.beta1'
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
end
```

At the top of *app/views/issues/show.html.erb*, set the current breadcrumb:

```erb
<% breadcrumb :issue, @issue %>
```

Then, in *app/views/layouts/application.html.erb*:

```erb
<%= breadcrumbs :pretext => "You are here: ",
                :separator => " &rsaquo; ",
                :semantic => true %>
```

This will generate a `<div class="breadcrumbs">` containing the breadcrumbs.

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

Options
-------

You can pass options to `<%= breadcrumbs %>`, e.g. `<%= breadcrumbs :pretext => "You are here:" %>`:

Option           | Description                                                                                                                | Default
---------------- | -------------------------------------------------------------------------------------------------------------------------- | -------
:pretext         | Text to be rendered before breadcrumb, e.g. `"You are here: "`                                                             | None
:posttext        | Text to be appended after breadcrumb, e.g. `"Text after breacrumb"`                                                        | None
:separator       | Separator between links, e.g. `" &rsaquo; "`                                                                               | `" &gt; "`
:autoroot        | Whether it should automatically link to the `:root` crumb if no parent is given.                                           | False
:show_root_alone | Whether it should show `:root` if that is the only link.                                                                   | False
:link_current    | Whether the current crumb should be linked to.                                                                             | False
:semantic        | Whether it should generate [semantic breadcrumbs](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=185417). | False
:id              | ID for the breadcrumbs container.                                                                                          | None
:class           | CSS class for the breadcrumbs container.                                                                                   | `"breadcrumbs"`
:current_class   | CSS class for the current link or span.                                                                                    | `"current"`

Documentation
-------------

* [Full documentation](http://rubydoc.info/github/lassebunk/gretel)
* [Changelog](https://github.com/lassebunk/gretel/blob/master/CHANGELOG.md)

Contributors
------------

* [See the list of contributors](https://github.com/lassebunk/gretel/graphs/contributors)

Copyright (c) 2010-2013 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
