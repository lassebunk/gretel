require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all

  test "shows basic breadcrumb" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with root" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent" do
    breadcrumb :with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <span class="current">Contact</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    assert_equal %{<div class="breadcrumbs"><span class="current">Test Project</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    assert_equal %{<div class="breadcrumbs"><a href="/projects/1">Test Project</a> &gt; <span class="current">Test Issue</span></div>},
                 breadcrumbs
  end

  test "shows multiple links" do
    breadcrumb :multiple_links
    assert_equal %{<div class="breadcrumbs"><a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "shows multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "shows semantic breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &gt; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>},
                 breadcrumbs(:semantic => true)
  end

  test "shows no breadcrumb" do
    assert_equal "", breadcrumbs
  end

  test "links current breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <a href="/about" class="current">About</a></div>},
                 breadcrumbs(:link_current => true)
  end

  test "shows pretext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">You are here: <span class="current">About</span></div>},
                 breadcrumbs(:pretext => "You are here: ")
  end

  test "shows posttext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span> - text after breadcrumbs</div>},
                 breadcrumbs(:posttext => " - text after breadcrumbs")
  end

  test "shows autoroot" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>},
                 breadcrumbs(:autoroot => true)
  end

  test "shows separator" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(:separator => " &rsaquo; ")
  end

  test "shows element id" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs" id="custom_id"><span class="current">About</span></div>},
                 breadcrumbs(:id => "custom_id")
  end

  test "unsafe html" do
    breadcrumb :with_unsafe_html
    assert_equal %{<div class="breadcrumbs"><span class="current">Test &lt;strong&gt;bold text&lt;/strong&gt;</span></div>},
                 breadcrumbs
  end

  test "safe html" do
    breadcrumb :with_safe_html
    assert_equal %{<div class="breadcrumbs"><span class="current">Test <strong>bold text</strong></span></div>},
                 breadcrumbs
  end

  test "works with legacy breadcrumb rendering method" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>},
                 breadcrumb
  end

  test "yields a block containing breadcrumb links array" do
    breadcrumb :multiple_links_with_parent

    out = nil # Needs to be defined here to be set inside block
    breadcrumbs do |links|
      out = links.map { |link| [link.key, link.text, link.url] }
    end

    assert_equal [[:basic, "About", "/about"],
                  [:multiple_links_with_parent, "Contact", "/about/contact"],
                  [:multiple_links_with_parent, "Contact form", "/about/contact/form"]], out
  end
end