require 'test_helper'

class DeprecatedTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all
  helper :application

  setup do
    Gretel.reset!
    Gretel.suppress_deprecation_warnings = true
  end

  test "show root alone" do
    breadcrumb :root
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>},
                 breadcrumbs(show_root_alone: true)
  end

  test "deprecated configuration block" do
    assert_raises RuntimeError do
      Gretel::Crumbs.layout do
      end
    end
  end

  test ":default style key" do
    breadcrumb :basic

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(style: :default)
  end
end