require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::HelperMethods
  fixtures :all

  test "shows root breadcrumb" do
    breadcrumb :root
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>},
                 breadcrumb
  end

  test "shows basic breadcrumb" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>},
                 breadcrumb
  end

  test "shows breadcrumb with root" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>},
                 breadcrumb
  end

  test "shows breadcrumb with parent" do
    breadcrumb :with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <span class="current">Contact</span></div>},
                 breadcrumb
  end

  test "shows breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    assert_equal %{<div class="breadcrumbs"><span class="current">Test Project</span></div>},
                 breadcrumb
  end

  test "shows breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    assert_equal %{<div class="breadcrumbs"><a href="/projects/1">Test Project</a> &gt; <span class="current">Test Issue</span></div>},
                 breadcrumb
  end

  test "shows multiple links" do
    breadcrumb :multiple_links
    assert_equal %{<div class="breadcrumbs"><a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>},
                 breadcrumb
  end

  test "shows multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>},
                 breadcrumb
  end

  test "shows semantic breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &gt; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>},
                 breadcrumb(:semantic => true)
  end

  test "shows no breadcrumb" do
    assert_equal "", breadcrumb
  end

  test "links current breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <a href="/about" class="current">About</a></div>},
                 breadcrumb(:link_current => true)
  end

  test "shows pretext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">You are here: <span class="current">About</span></div>},
                 breadcrumb(:pretext => "You are here: ")
  end

  test "shows posttext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span> - text after breadcrumbs</div>},
                 breadcrumb(:posttext => " - text after breadcrumbs")
  end

  test "shows autoroot" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>},
                 breadcrumb(:autoroot => true)
  end

  test "shows separator" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumb(:separator => " &rsaquo; ")
  end

  test "shows element id" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs" id="custom_id"><span class="current">About</span></div>},
                 breadcrumb(:id => "custom_id")
  end

  test "renders proc" do
    breadcrumb :with_proc
    assert_equal %{<div class="breadcrumbs"><a href="URL from proc" class="current">Name from proc</a></div>},
                 breadcrumb(:link_current => true)
  end
end