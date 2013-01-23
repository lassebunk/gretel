require 'test_helper'

class HelperMethodsTest < ActiveSupport::TestCase
  class MockView < ActionView::Base
    include Rails.application.routes.url_helpers
  end

  fixtures :all

  setup do
    @view = MockView.new
  end

  test "should show root breadcrumb" do
    @view.breadcrumb :root
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>}, response
  end

  test "should show basic breadcrumb" do
    @view.breadcrumb :basic
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>}, response
  end

  test "should show breadcrumb with root" do
    @view.breadcrumb :with_root
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response
  end

  test "should show breadcrumb with parent" do
    @view.breadcrumb :with_parent
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <span class="current">Contact</span></div>}, response
  end

  test "should show breadcrumb with autopath" do
    @view.breadcrumb :with_autopath, projects(:one)
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><span class="current">Test Project</span></div>}, response
  end

  test "should show breadcrumb with parent object" do
    @view.breadcrumb :with_parent_object, issues(:one)
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/projects/1">Test Project</a> &gt; <span class="current">Test Issue</span></div>}, response
  end

  test "should show multiple links" do
    @view.breadcrumb :multiple_links
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response
  end

  test "should show multiple links with parent" do
    @view.breadcrumb :multiple_links_with_parent
    response = @view.breadcrumb
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response
  end

  test "should show semantic breadcrumb" do
    @view.breadcrumb :with_root
    response = @view.breadcrumb(:semantic => true)
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &gt; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>}, response
  end

  test "should show no breadcrumb" do
    assert_equal "", @view.breadcrumb
  end

  test "should link current breadcrumb" do
    @view.breadcrumb :with_root
    response = @view.breadcrumb(:link_current => true)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <a href="/about" class="current">About</a></div>}, response
  end

  test "should show pretext" do
    @view.breadcrumb :basic
    response = @view.breadcrumb(:pretext => "You are here: ")
    assert_equal %{<div class="breadcrumbs">You are here: <span class="current">About</span></div>}, response
  end

  test "should show posttext" do
    @view.breadcrumb :basic
    response = @view.breadcrumb(:posttext => " - text after breadcrumbs")
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span> - text after breadcrumbs</div>}, response
  end

  test "should show autoroot" do
    @view.breadcrumb :basic
    response = @view.breadcrumb(:autoroot => true)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response
  end

  test "should show separator" do
    @view.breadcrumb :with_root
    response = @view.breadcrumb(:separator => " &rsaquo; ")
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, response
  end

  test "should show element id" do
    @view.breadcrumb :basic
    response = @view.breadcrumb(:id => "custom_id")
    assert_equal %{<div class="breadcrumbs" id="custom_id"><span class="current">About</span></div>}, response
  end
end