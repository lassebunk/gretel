require 'test_helper'

class TestControllerTest < ActionController::TestCase
  fixtures :all

  test "should show root breadcrumb" do
    get :root
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>}, response.body
  end

  test "should show basic breadcrumb" do
    get :basic
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span></div>}, response.body
  end

  test "should show breadcrumb with root" do
    get :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response.body
  end

  test "should show breadcrumb with parent" do
    get :with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <span class="current">Contact</span></div>}, response.body
  end

  test "should show breadcrumb with autopath" do
    get :with_autopath
    assert_equal %{<div class="breadcrumbs"><span class="current">Test Project</span></div>}, response.body
  end

  test "should show breadcrumb with parent object" do
    get :with_parent_object
    assert_equal %{<div class="breadcrumbs"><a href="/projects/1">Test Project</a> &gt; <span class="current">Test Issue</span></div>}, response.body
  end

  test "should show multiple links" do
    get :multiple_links
    assert_equal %{<div class="breadcrumbs"><a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response.body
  end

  test "should show multiple links with parent" do
    get :multiple_links_with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/about">About</a> &gt; <a href="/about/contact">Contact</a> &gt; <span class="current">Contact form</span></div>}, response.body
  end

  test "should show semantic breadcrumb" do
    get :semantic
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &gt; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>}, response.body
  end

  test "should show no breadcrumb" do
    get :no_breadcrumb
    assert_equal "", response.body
  end

  test "should link current breadcrumb" do
    get :link_current
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <a href="/about" class="current">About</a></div>}, response.body
  end

  test "should show pretext" do
    get :pretext
    assert_equal %{<div class="breadcrumbs">You are here: <span class="current">About</span></div>}, response.body
  end

  test "should show posttext" do
    get :posttext
    assert_equal %{<div class="breadcrumbs"><span class="current">About</span> - text after breadcrumbs</div>}, response.body
  end

  test "should show autoroot" do
    get :autoroot
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &gt; <span class="current">About</span></div>}, response.body
  end

  test "should show separator" do
    get :separator
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, response.body
  end

  test "should show element id" do
    get :element_id
    assert_equal %{<div class="breadcrumbs" id="custom_id"><span class="current">About</span></div>}, response.body
  end

end
