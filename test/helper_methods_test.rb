require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::HelperMethods
  fixtures :all

  test "should show root breadcrumb" do
    breadcrumb :root
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>}, response
  end

  test "should show basic breadcrumb" do
    breadcrumb :basic
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>}, response
  end

  test "should show breadcrumb with root" do
    breadcrumb :with_root
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response
  end

  test "should show breadcrumb with parent" do
    breadcrumb :with_parent
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <span class="current">Contact</span></div>}, response
  end

  test "should show breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">Test Project</span></div>}, response
  end

  test "should show breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/projects/1">Test Project</a> &gt; <span class="current">Test Issue</span></div>}, response
  end

  test "should show multiple links" do
    breadcrumb :multiple_links
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response
  end

  test "should show multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    response = breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response
  end

  test "should show semantic breadcrumb" do
    breadcrumb :with_root
    response = breadcrumb(:semantic => true)
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &gt; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>}, response
  end

  test "should show no breadcrumb" do
    assert_equal "", breadcrumb
  end

  test "should link current breadcrumb" do
    breadcrumb :with_root
    response = breadcrumb(:link_current => true)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <a href="/about" class="current">About</a></div>}, response
  end

  test "should show pretext" do
    breadcrumb :basic
    response = breadcrumb(:pretext => "You are here: ")
    assert_equal %{<div class="breadcrumbs">You are here: <span class="current">About</span></div>}, response
  end

  test "should show posttext" do
    breadcrumb :basic
    response = breadcrumb(:posttext => " - text after breadcrumbs")
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span> - text after breadcrumbs</div>}, response
  end

  test "should show autoroot" do
    breadcrumb :basic
    response = breadcrumb(:autoroot => true)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response
  end

  test "should show separator" do
    breadcrumb :with_root
    response = breadcrumb(:separator => " &rsaquo; ")
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, response
  end

  test "should show element id" do
    breadcrumb :basic
    response = breadcrumb(:id => "custom_id")
    assert_equal %{<div class="breadcrumbs" id="custom_id"><span class="current">About</span></div>}, response
  end
end