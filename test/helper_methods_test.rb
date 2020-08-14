require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::ViewHelpers

  self.fixture_path = File.expand_path("../../test/fixtures", __FILE__)
  fixtures :all

  helper :application

  setup do
    Gretel.reset!
  end

  def itemscope_value
    ActionView::Helpers::TagHelper::BOOLEAN_ATTRIBUTES.include?("itemscope") ?
      "itemscope" : ""
  end

  # Breadcrumb generation

  test "basic breadcrumb" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs.to_s
  end

  test "breadcrumb with root" do
    breadcrumb :with_root
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs.to_s
  end

  test "breadcrumb with parent" do
    breadcrumb :with_parent
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>},
                 breadcrumbs.to_s
  end

  test "breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test Project</span></div>},
                 breadcrumbs.to_s
  end

  test "breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test Issue</span></div>},
                 breadcrumbs.to_s
  end

  test "multiple links" do
    breadcrumb :multiple_links
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs.to_s
  end

  test "multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs.to_s
  end

  test "semantic breadcrumb" do
    breadcrumb :with_root
    assert_dom_equal %{<div class="breadcrumbs" itemscope="#{itemscope_value}" itemtype="https://schema.org/BreadcrumbList"><span itemprop="itemListElement" itemscope="#{itemscope_value}" itemtype="https://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a><meta itemprop="position" content="1" /></span> &rsaquo; <span class="current" itemprop="itemListElement" itemscope="#{itemscope_value}" itemtype="https://schema.org/ListItem"><span itemprop="name">About</span><meta itemprop="item" content="http://test.host/about" /><meta itemprop="position" content="2" /></span></div>},
                 breadcrumbs(semantic: true).to_s
  end

  test "doesn't show root alone" do
    breadcrumb :root
    assert_dom_equal "", breadcrumbs.to_s
  end

  test "displays single fragment" do
    breadcrumb :root
    assert_dom_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>},
                 breadcrumbs(display_single_fragment: true).to_s
  end

  test "displays single non-root fragment" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><span class="current">About</span></div>},
                 breadcrumbs(autoroot: false, display_single_fragment: true).to_s
  end

  test "no breadcrumb" do
    assert_dom_equal "", breadcrumbs.to_s
  end

  test "links current breadcrumb" do
    breadcrumb :with_root
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about" class="current">About</a></div>},
                 breadcrumbs(link_current: true).to_s
  end

  test "pretext" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><span class="pretext">You are here:</span> <a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(pretext: "You are here:").to_s
  end

  test "posttext" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span> <span class="posttext">text after breadcrumbs</span></div>},
                 breadcrumbs(posttext: "text after breadcrumbs").to_s
  end

  test "autoroot disabled" do
    breadcrumb :basic
    assert_dom_equal "", breadcrumbs(autoroot: false).to_s
  end

  test "separator" do
    breadcrumb :with_root
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &raquo; <span class="current">About</span></div>},
                 breadcrumbs(separator: " &raquo; ").to_s
  end

  test "element id" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs" id="custom_id"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(id: "custom_id").to_s
  end

  test "custom container class" do
    breadcrumb :basic
    assert_dom_equal %{<div class="custom_class"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(class: "custom_class").to_s
  end

  test "custom fragment class" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a class="custom_fragment_class" href="/">Home</a> &rsaquo; <span class="custom_fragment_class current">About</span></div>},
                 breadcrumbs(fragment_class: "custom_fragment_class").to_s
  end

  test "custom current class" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="custom_current_class">About</span></div>},
                 breadcrumbs(current_class: "custom_current_class").to_s
  end

  test "custom pretext class" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><span class="custom_pretext_class">You are here:</span> <a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(pretext: "You are here:", pretext_class: "custom_pretext_class").to_s
  end

  test "custom posttext class" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span> <span class="custom_posttext_class">after breadcrumbs</span></div>},
                 breadcrumbs(posttext: "after breadcrumbs", posttext_class: "custom_posttext_class").to_s
  end

  test "unsafe html" do
    breadcrumb :with_unsafe_html
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test &lt;strong&gt;bold text&lt;/strong&gt;</span></div>},
                 breadcrumbs.to_s
  end

  test "safe html" do
    breadcrumb :with_safe_html
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test <strong>bold text</strong></span></div>},
                 breadcrumbs.to_s
  end

  test "parent breadcrumb" do
    breadcrumb :multiple_links_with_parent

    parent = parent_breadcrumb
    assert_equal [:multiple_links_with_parent, "Contact", "/about/contact"],
                 [parent.key, parent.text, parent.url]
  end

  test "yields parent breadcrumb" do
    breadcrumb :multiple_links_with_parent

    out = parent_breadcrumb do |parent|
      [parent.key, parent.text, parent.url]
    end
    assert_equal [:multiple_links_with_parent, "Contact", "/about/contact"],
                 out
  end

  test "parent breadcrumb returns nil if not present" do
    breadcrumb :basic

    assert_nil parent_breadcrumb(autoroot: false)
  end

  test "parent breadcrumb yields only if present" do
    breadcrumb :basic

    out = parent_breadcrumb(autoroot: false) do
      "yielded"
    end

    assert_nil out
  end

  test "link keys" do
    breadcrumb :basic
    assert_equal [:root, :basic], breadcrumbs.keys
  end

  test "using breadcrumbs as array" do
    breadcrumb :basic

    breadcrumbs.tap do |links|
      assert_kind_of Array, links
      assert_equal 2, links.count
    end
  end

  test "sets current on last link in array" do
    breadcrumb :multiple_links_with_parent
    assert_equal [false, false, false, true], breadcrumbs.map(&:current?)
  end

  test "passing options to links" do
    breadcrumb :with_link_options

    breadcrumbs(autoroot: false).tap do |links|
      links[0].tap do |link|
        assert link.title?
        assert_equal "My Title", link.title

        assert link.other?
        assert_equal "Other Option", link.other

        assert !link.nonexistent?
        assert_nil link.nonexistent
      end

      links[1].tap do |link|
        assert link.some_option?
        assert_equal "Test", link.some_option
      end
    end

    assert_dom_equal %{<div class="breadcrumbs"><a href="/about">Test</a> &rsaquo; <span class="current">Other Link</span></div>},
                 breadcrumbs(autoroot: false).to_s
  end

  test "without link" do
    breadcrumb :without_link
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; Also without link &rsaquo; <span class="current">Without link</span></div>},
                 breadcrumbs.to_s
  end

  test "view context" do
    breadcrumb :using_view_helper
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">TestTest</span></div>},
                 breadcrumbs.to_s
  end

  test "multiple arguments" do
    breadcrumb :with_multiple_arguments, "One", "Two", "Three"
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">First OneOne then TwoTwo then ThreeThree</a> &rsaquo; <span class="current">One and Two and Three</span></div>},
                 breadcrumbs.to_s
  end

  test "from views folder" do
    breadcrumb :from_views
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Breadcrumb From View</span></div>},
                 breadcrumbs.to_s
  end

  test "with_breadcrumb" do
    breadcrumb :basic

    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs.to_s

    with_breadcrumb(:with_parent_object, issues(:one)) do
      assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test Issue</span></div>},
                   breadcrumbs.to_s
    end

    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs.to_s
  end

  test "calling breadcrumbs helper twice" do
    breadcrumb :with_parent
    2.times do
      assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>},
                   breadcrumbs.to_s
    end
  end

  test "breadcrumb not found" do
    assert_raises ArgumentError do
      breadcrumb :nonexistent
      breadcrumbs
    end
  end

  test "current link url is set to fullpath" do
    self.request = OpenStruct.new(fullpath: "/testpath?a=1&b=2")

    breadcrumb :basic
    assert_equal "/testpath?a=1&b=2", breadcrumbs.last.url
  end

  test "current link url is not set to fullpath using link_current_to_request_path=false" do
    self.request = OpenStruct.new(fullpath: "/testpath?a=1&b=2")

    breadcrumb :basic
    assert_equal "/about", breadcrumbs(:link_current_to_request_path => false).last.url
  end

  test "calling the breadcrumb method with wrong arguments" do
    assert_nothing_raised do
      breadcrumb :basic, test: 1
    end

    assert_raises ArgumentError do
      breadcrumb
    end

    assert_raises ArgumentError do
      breadcrumb(pretext: "bla")
    end
  end

  test "inferred breadcrumb" do
    breadcrumb Project.first
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test Project</span></div>},
                 breadcrumbs.to_s
  end

  test "inferred parent" do
    breadcrumb :with_inferred_parent

    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test</span></div>},
                     breadcrumbs.to_s
  end

  # Styles

  test "default style" do
    breadcrumb :basic
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs.to_s
  end

  test "ordered list style" do
    breadcrumb :basic
    assert_dom_equal %{<ol class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ol>},
                 breadcrumbs(style: :ol).to_s
  end

  test "unordered list style" do
    breadcrumb :basic
    assert_dom_equal %{<ul class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ul>},
                 breadcrumbs(style: :ul).to_s
  end

  test "bootstrap style" do
    breadcrumb :basic
    assert_dom_equal %{<ol class="breadcrumb"><li><a href="/">Home</a></li><li class="active">About</li></ol>},
                 breadcrumbs(style: :bootstrap).to_s
  end

  test "bootstrap4 style" do
    breadcrumb :basic
    assert_dom_equal %{<ol class="breadcrumb"><li class="breadcrumb-item"><a href="/">Home</a></li><li class="breadcrumb-item active">About</li></ol>},
                 breadcrumbs(style: :bootstrap4).to_s
  end

  test "foundation5 style" do
    breadcrumb :basic
    assert_dom_equal %{<ul class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ul>},
                 breadcrumbs(style: :foundation5).to_s
  end

  test "custom container and fragment tags" do
    breadcrumb :basic
    assert_dom_equal %{<c class="breadcrumbs"><f><a href="/">Home</a></f> &rsaquo; <f class="current">About</f></c>},
                 breadcrumbs(container_tag: :c, fragment_tag: :f).to_s
  end

  test "custom semantic container and fragment tags" do
    breadcrumb :basic
    assert_dom_equal %{<c class="breadcrumbs" itemscope="#{itemscope_value}" itemtype="https://schema.org/BreadcrumbList"><f itemprop="itemListElement" itemscope="#{itemscope_value}" itemtype="https://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a><meta itemprop="position" content="1" /></f> &rsaquo; <f class="current" itemprop="itemListElement" itemscope="#{itemscope_value}" itemtype="https://schema.org/ListItem"><span itemprop="name">About</span><meta itemprop="item" content="http://test.host/about" /><meta itemprop="position" content="2" /></f></c>},
                 breadcrumbs(container_tag: :c, fragment_tag: :f, semantic: true).to_s
  end

  test "unknown style" do
    breadcrumb :basic
    assert_raises ArgumentError do
      breadcrumbs(style: :nonexistent)
    end
  end

  test "register style" do
    Gretel.register_style :test_style, { container_tag: :one, fragment_tag: :two }

    breadcrumb :basic

    assert_dom_equal %{<one class="breadcrumbs"><two><a href="/">Home</a></two><two class="current">About</two></one>},
                 breadcrumbs(style: :test_style).to_s
  end

  # Configuration reload

  test "reload configuration when file is changed" do
    path = setup_loading_from_tmp_folder
    Gretel.reload_environments << "test"

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (loaded)", root_path
        end
        crumb :about do
          link "About (loaded)", about_path
        end
      EOT
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s

    sleep 1 # File change interval is 1 second

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (reloaded)", "/test"
        end
        crumb :about do
          link "About (reloaded)", "/reloaded"
        end
      EOT
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/test">Home (reloaded)</a> &rsaquo; <span class="current">About (reloaded)</span></div>}, breadcrumbs.to_s
  end

  test "reload configuration when file is added" do
    path = setup_loading_from_tmp_folder
    Gretel.reload_environments << "test"

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (loaded)", root_path
        end
      EOT
    end

    assert_raises ArgumentError do
      breadcrumb :about
      breadcrumbs
    end

    File.open(path.join("pages.rb"), "w") do |f|
      f.write <<-EOT
        crumb :about do
          link "About (loaded)", about_path
        end
      EOT
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s
  end

  test "reload configuration when file is deleted" do
    path = setup_loading_from_tmp_folder
    Gretel.reload_environments << "test"

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (loaded)", root_path
        end
        crumb :about do
          link "About (loaded)", about_path
        end
      EOT
    end

    File.open(path.join("pages.rb"), "w") do |f|
      f.write <<-EOT
        crumb :contact do
          link "Contact (loaded)", "/contact"
          parent :about
        end
      EOT
    end

    breadcrumb :contact
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <a href="/about">About (loaded)</a> &rsaquo; <span class="current">Contact (loaded)</span></div>}, breadcrumbs.to_s

    File.delete path.join("pages.rb")

    assert_raises ArgumentError do
      breadcrumb :contact
      breadcrumbs
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s
  end

  test "reloads only in development environment" do
    path = setup_loading_from_tmp_folder

    assert_equal ["development"], Gretel.reload_environments

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (loaded)", root_path
        end
        crumb :about do
          link "About (loaded)", about_path
        end
      EOT
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s

    sleep 1

    File.open(path.join("site.rb"), "w") do |f|
      f.write <<-EOT
        crumb :root do
          link "Home (reloaded)", "/test"
        end
        crumb :about do
          link "About (reloaded)", "/reloaded"
        end
      EOT
    end

    breadcrumb :about
    assert_dom_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s
  end

private

  def setup_loading_from_tmp_folder
    path = Rails.root.join("tmp", "testcrumbs")
    FileUtils.rm_rf path
    FileUtils.mkdir_p path

    Gretel.breadcrumb_paths = [path.join("*.rb")]

    path
  end
end
