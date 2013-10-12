require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all
  helper :application

  setup do
    Gretel.reset!
    Gretel::Trail.secret = "128107d341e912db791d98bbe874a8250f784b0a0b4dbc5d5032c0fc1ca7bda9c6ece667bd18d23736ee833ea79384176faeb54d2e0d21012898dde78631cdf1"
  end

  # Breadcrumb generation

  test "shows basic breadcrumb" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with root" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent" do
    breadcrumb :with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with autopath" do
    breadcrumb :with_autopath, projects(:one)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test Project</span></div>},
                 breadcrumbs
  end

  test "shows breadcrumb with parent object" do
    breadcrumb :with_parent_object, issues(:one)
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test Issue</span></div>},
                 breadcrumbs
  end

  test "shows multiple links" do
    breadcrumb :multiple_links
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "shows multiple links with parent" do
    breadcrumb :multiple_links_with_parent
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "shows semantic breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></div> &rsaquo; <div itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span class="current" itemprop="title">About</span></div></div>},
                 breadcrumbs(semantic: true)
  end

  test "doesn't show root alone" do
    breadcrumb :root
    assert_equal "", breadcrumbs
  end

  test "displays single fragment" do
    breadcrumb :root
    assert_equal %{<div class="breadcrumbs"><span class="current">Home</span></div>},
                 breadcrumbs(display_single_fragment: true)
  end

  test "shows no breadcrumb" do
    assert_equal "", breadcrumbs
  end

  test "links current breadcrumb" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about" class="current">About</a></div>},
                 breadcrumbs(link_current: true)
  end

  test "shows pretext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs">You are here: <a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(pretext: "You are here: ")
  end

  test "shows posttext" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span> - text after breadcrumbs</div>},
                 breadcrumbs(posttext: " - text after breadcrumbs")
  end

  test "autoroot disabled" do
    breadcrumb :basic
    assert_equal "", breadcrumbs(autoroot: false)
  end

  test "shows separator" do
    breadcrumb :with_root
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &raquo; <span class="current">About</span></div>},
                 breadcrumbs(separator: " &raquo; ")
  end

  test "shows element id" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs" id="custom_id"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(id: "custom_id")
  end

  test "shows custom container class" do
    breadcrumb :basic
    assert_equal %{<div class="custom_class"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs(class: "custom_class")
  end

  test "shows custom current class" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="custom_current_class">About</span></div>},
                 breadcrumbs(current_class: "custom_current_class")
  end

  test "unsafe html" do
    breadcrumb :with_unsafe_html
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test &lt;strong&gt;bold text&lt;/strong&gt;</span></div>},
                 breadcrumbs
  end

  test "safe html" do
    breadcrumb :with_safe_html
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test <strong>bold text</strong></span></div>},
                 breadcrumbs
  end

  test "yields a block containing breadcrumb links array" do
    breadcrumb :multiple_links_with_parent

    out = breadcrumbs do |links|
      links.map { |link| [link.key, link.text, link.url] }
    end

    assert_equal [[:root, "Home", "/"],
                  [:basic, "About", "/about"],
                  [:multiple_links_with_parent, "Contact", "/about/contact"],
                  [:multiple_links_with_parent, "Contact form", "/about/contact/form"]], out
  end

  test "without link" do
    breadcrumb :without_link
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; Also without link &rsaquo; <span class="current">Without link</span></div>},
                 breadcrumbs
  end

  test "view context" do
    breadcrumb :using_view_helper
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">TestTest</span></div>},
                 breadcrumbs
  end

  test "multiple arguments" do
    breadcrumb :with_multiple_arguments, "One", "Two", "Three"
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">First OneOne then TwoTwo then ThreeThree</a> &rsaquo; <span class="current">One and Two and Three</span></div>},
                 breadcrumbs
  end

  test "calling breadcrumbs helper twice" do
    breadcrumb :with_parent
    2.times do
      assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>},
                   breadcrumbs
    end
  end

  test "breadcrumb not found" do
    assert_raises ArgumentError do
      breadcrumb :nonexistent
      breadcrumbs
    end
  end

  test "current link url is set to fullpath" do
    self.request = Struct.new(:fullpath).new("/testpath?a=1&b=2")

    breadcrumb :basic
    assert_equal "/testpath?a=1&b=2", breadcrumbs { |links| links.last.url }
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

  # Styles

  test "default style" do
    breadcrumb :basic
    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>},
                 breadcrumbs
  end

  test "ordered list style" do
    breadcrumb :basic
    assert_equal %{<ol class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ol>},
                 breadcrumbs(style: :ol)
  end

  test "unordered list style" do
    breadcrumb :basic
    assert_equal %{<ul class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ul>},
                 breadcrumbs(style: :ul)
  end

  test "bootstrap style" do
    breadcrumb :basic
    assert_equal %{<ol class="breadcrumb"><li><a href="/">Home</a></li><li class="active">About</li></ol>},
                 breadcrumbs(style: :bootstrap)
  end

  test "custom container and fragment tags" do
    breadcrumb :basic
    assert_equal %{<c class="breadcrumbs"><f><a href="/">Home</a></f> &rsaquo; <f class="current">About</f></c>},
                 breadcrumbs(container_tag: :c, fragment_tag: :f)
  end

  test "custom semantic container and fragment tags" do
    breadcrumb :basic
    assert_equal %{<c class="breadcrumbs"><f itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></f> &rsaquo; <f class="current" itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><span itemprop="title">About</span></f></c>},
                 breadcrumbs(container_tag: :c, fragment_tag: :f, semantic: true)
  end

  test "unknown style" do
    breadcrumb :basic
    assert_raises ArgumentError do
      breadcrumbs(style: :nonexistent)
    end
  end

  # Trails

  test "trail helper" do
    breadcrumb :basic

    assert_equal "12MoG3DY5eLzU_W1siYmFzaWMiLCJBYm91dCIsIi9hYm91dCJdXQ==", breadcrumb_trail
  end

  test "loading trail" do
    params[:trail] = "12MoG3DY5eLzU_W1siYmFzaWMiLCJBYm91dCIsIi9hYm91dCJdXQ=="
    breadcrumb :multiple_links

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "different trail param" do
    Gretel::Trail.trail_param = :mytest
    params[:mytest] = "12MoG3DY5eLzU_W1siYmFzaWMiLCJBYm91dCIsIi9hYm91dCJdXQ=="
    breadcrumb :multiple_links

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
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
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs

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
    assert_equal %{<div class="breadcrumbs"><a href="/test">Home (reloaded)</a> &rsaquo; <span class="current">About (reloaded)</span></div>}, breadcrumbs
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
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs
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
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <a href="/about">About (loaded)</a> &rsaquo; <span class="current">Contact (loaded)</span></div>}, breadcrumbs

    File.delete path.join("pages.rb")

    assert_raises ArgumentError do
      breadcrumb :contact
      breadcrumbs
    end

    breadcrumb :about
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs
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
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs

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
    assert_equal %{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs
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