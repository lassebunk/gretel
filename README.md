Gretel is a [Ruby on Rails](http://rubyonrails.org) plugin that makes it easy yet flexible to create breadcrumbs.


Installation
------------

In your *Gemfile*:

```ruby
gem 'gretel'
```

And run `bundle install`.


Example
-------

Start by generating an initializer:

```bash
$ rails generate gretel:install
```

Then, in *config/initializers/breadcrumbs.rb*:

```ruby
Gretel::Crumbs.layout do
  
  # root crumb
  crumb :root do
    link "Home", root_path
  end
  
  # custom styles
  crumb :projects do
    link "Projects", projects_path, :class => "breadcrumb", :style => "font-weight: bold;"
  end

  # lambdas
  crumb :project do |project|
    link lambda { |project| "#{project.name} (#{project.id.to_s})" }, project_path(project)
    parent :projects
  end
  
  # parent crumbs
  crumb :project_issues do |project|
    link "Issues", project_issues_path(project)
    parent :project, project
  end
  
  # child 
  crumb :issue do |issue|
    link issue.name, issue_path(issue)
    parent :project_issues, issue.project
  end
  
  # multiple links per crumb (recursive links for parent categories)
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
  
  # product crumb with recursive parent categories
  crumb :product do |product|
    link product.name, product
    parent :category, product.category
  end
end
```

At the top of *app/views/issues/show.html.erb*:

```erb
<% breadcrumb :issue, @issue %>
```

In *app/views/layouts/application.html.erb*:

```erb
<%= breadcrumb :pretext => "You are here: ",
               :posttext => " &laquo; that was the breadcrumbs!",
               :separator => " &rsaquo; ",
               :autoroot => true,
               :show_root_alone => true,
               :link_current => false,
               :semantic => true,
               :id => "topcrumbs"
               %>
```

This will generate a `<div>` containing the breadcrumbs.

Or, if you want to customize your breadcrumbs:

```erb
<% breadcrumbs(:autoroot => true, :show_root_alone => false).each_with_index do |crumb, index| %>
  <% if index > 0 %> &gt;<% end %>
  <% if crumb.current? %>
    <span class="current"><%= crumb.text %></span>
  <% else %>
    <%= link_to crumb.text, crumb.url %>
  <% end %>
<% end %>
```

Options for <code><%= breadcrumb %></code>:

**:pretext**
Text to be rendered before breadcrumb, if any. Default: none

**:posttext**
Text to be appended after breadrcumb, if any: Default: none

**:separator**
Separator between links. Default: `&gt;`

**:autoroot**
Whether it should automatically link to :root if no root parent is given. Default: false

**:show_root_alone**
Whether it should show :root if this is the only link. Default: false

**:link_current**
Whether the current crumb should be linked to. Default: false

**:semantic**
Whether it should generate [semantic breadcrumbs](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=185417).
Default: false

**:id**
HTML element ID to be inserted. Default: none

Contributors
------------

* [See the list of contributors](https://github.com/lassebunk/gretel/graphs/contributors)

Copyright (c) 2010-2013 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
