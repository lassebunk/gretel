require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all
  helper :application

  test "shows basic breadcrumb" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs
  end

  test "shows breadcrumb with root" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent" do
    breadcrumb :with_parent
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about">About</a> &gt;\n  <span class="current">Contact</span>\n</div>},
                 breadcrumbs
  end

  test "shows breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">Test Project</span>\n</div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/projects/1">Test Project</a> &gt;\n  <span class="current">Test Issue</span>\n</div>},
                 breadcrumbs
  end

  test "shows multiple links" do
    breadcrumb :multiple_links
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about/contact">Contact</a> &gt;\n  <span class="current">Contact form</span>\n</div>},
                 breadcrumbs
  end

  test "shows multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about">About</a> &gt;\n  <a href="/about/contact">Contact</a> &gt;\n  <span class="current">Contact form</span>\n</div>},
                 breadcrumbs
  end

  test "shows semantic breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs">\n  <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">\n    <a href="/" itemprop="url"><span itemprop="title">Home</span></a>\n  </div> &gt;\n  <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">\n    <span class="current" itemprop="title">About</span>\n  </div>\n</div>},
                 breadcrumbs(:semantic => true)
  end

  test "doesn't show root alone" do
    breadcrumb :root
    assert_equal "", breadcrumbs
  end

  test "shows root alone" do
    breadcrumb :root
    assert_equal %{<div class="breadcrumbs">\n  <span class="current">Home</span>\n</div>},
                 breadcrumbs(:show_root_alone => true)
  end

  test "shows no breadcrumb" do
    assert_equal "", breadcrumbs
  end

  test "links current breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about" class="current">About</a>\n</div>},
                 breadcrumbs(:link_current => true)
  end

  test "shows pretext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  You are here:\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs(:pretext => "You are here:")
  end

  test "shows posttext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n  - text after breadcrumbs\n</div>},
                 breadcrumbs(:posttext => "- text after breadcrumbs")
  end

  test "autoroot disabled" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  <span class="current">About</span>\n</div>},
                 breadcrumbs(:autoroot => false)
  end

  test "shows separator" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &rsaquo;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs(:separator => "&rsaquo;")
  end

  test "shows element id" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs" id="custom_id">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs(:id => "custom_id")
  end

  test "shows custom container class" do
    breadcrumb :basic
    assert_equal %{<div class="custom_class">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumbs(:class => "custom_class")
  end

  test "shows custom current class" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="custom_current_class">About</span>\n</div>},
                 breadcrumbs(:current_class => "custom_current_class")
  end

  test "unsafe html" do
    breadcrumb :with_unsafe_html
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">Test &lt;strong&gt;bold text&lt;/strong&gt;</span>\n</div>},
                 breadcrumbs
  end

  test "safe html" do
    breadcrumb :with_safe_html
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">Test <strong>bold text</strong></span>\n</div>},
                 breadcrumbs
  end

  test "works with legacy breadcrumb rendering method" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">About</span>\n</div>},
                 breadcrumb
  end

  test "yields a block containing breadcrumb links array" do
    breadcrumb :multiple_links_with_parent

    out = nil # Needs to be defined here to be set inside block and then accessed outside
    breadcrumbs do |links|
      out = links.map { |link| [link.key, link.text, link.url] }
    end

    assert_equal [[:root, "Home", "/"],
                  [:basic, "About", "/about"],
                  [:multiple_links_with_parent, "Contact", "/about/contact"],
                  [:multiple_links_with_parent, "Contact form", "/about/contact/form"]], out
  end

  test "without link" do
    breadcrumb :without_link
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  Also without link &gt;\n  <span class="current">Without link</span>\n</div>},
                 breadcrumbs
  end

  test "view context" do
    breadcrumb :using_view_helper
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <span class="current">TestTest</span>\n</div>},
                 breadcrumbs
  end

  test "multiple arguments" do
    breadcrumb :with_multiple_arguments, "One", "Two", "Three"
    assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about">First OneOne then TwoTwo then ThreeThree</a> &gt;\n  <span class="current">One and Two and Three</span>\n</div>},
                 breadcrumb
  end

  test "calling breadcrumbs helper twice" do
    breadcrumb :with_parent
    2.times do
      assert_equal %{<div class="breadcrumbs">\n  <a href="/">Home</a> &gt;\n  <a href="/about">About</a> &gt;\n  <span class="current">Contact</span>\n</div>},
                   breadcrumbs
    end
  end
end