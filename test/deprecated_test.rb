require 'test_helper'

class DeprecatedTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all
  helper :application

  setup do
    Gretel.reset!
  end

  test "deprecated configuration block" do
    Gretel.suppress_deprecation_warnings = true
    
    Gretel::Crumbs.layout do
      crumb :deprecated_parent do
        link "Test deprecated", root_path
      end

      crumb :deprecated_child do
        link "Child", about_path
        parent :deprecated_parent
      end
    end

    breadcrumb :deprecated_child
    assert_equal %{<div class="breadcrumbs"><a href="/">Test deprecated</a> &gt; <span class="current">Child</span></div>},
                 breadcrumbs(:autoroot => false)
  end
end