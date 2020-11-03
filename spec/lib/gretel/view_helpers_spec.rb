require "rails_helper"

describe Gretel::ViewHelpers, type: :helper do
  helper :application
  fixtures :all

  before(:context) { ActionView::Base } # fire `run_load_hooks :action_view`
  before { Gretel.reset! }

  describe "Breadcrumb generation" do
    it "basic breadcrumb" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs.to_s)
    end

    it "breadcrumb with root" do
      breadcrumb :with_root
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs.to_s)
    end

    it "breadcrumb with parent" do
      breadcrumb :with_parent
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>}, breadcrumbs.to_s)
    end

    it "breadcrumb with autopath" do
      breadcrumb :with_autopath, projects(:one)
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test Project</span></div>}, breadcrumbs.to_s)
    end

    it "breadcrumb with parent object" do
      breadcrumb :with_parent_object, issues(:one)
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test Issue</span></div>}, breadcrumbs.to_s)
    end

    it "multiple links" do
      breadcrumb :multiple_links
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>}, breadcrumbs.to_s)
    end

    it "multiple links with parent" do
      breadcrumb :multiple_links_with_parent
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>}, breadcrumbs.to_s)
    end

    it "semantic breadcrumb" do
      breadcrumb :with_root
      assert_dom_equal(%{<div class="breadcrumbs" itemscope="itemscope" itemtype="https://schema.org/BreadcrumbList"><span itemprop="itemListElement" itemscope="itemscope" itemtype="https://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a><meta itemprop="position" content="1" /></span> &rsaquo; <span class="current" itemprop="itemListElement" itemscope="itemscope" itemtype="https://schema.org/ListItem"><span itemprop="name">About</span><meta itemprop="item" content="http://test.host/about" /><meta itemprop="position" content="2" /></span></div>}, breadcrumbs(semantic: true).to_s)
    end

    it "doesn't show root alone" do
      breadcrumb :root
      assert_dom_equal("", breadcrumbs.to_s)
    end

    it "displays single fragment" do
      breadcrumb :root
      assert_dom_equal(%{<div class="breadcrumbs"><span class="current">Home</span></div>}, breadcrumbs(display_single_fragment: true).to_s)
    end

    it "displays single non-root fragment" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><span class="current">About</span></div>}, breadcrumbs(autoroot: false, display_single_fragment: true).to_s)
    end

    it "no breadcrumb" do
      assert_dom_equal("", breadcrumbs.to_s)
    end

    it "links current breadcrumb" do
      breadcrumb :with_root
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about" class="current">About</a></div>}, breadcrumbs(link_current: true).to_s)
    end

    it "pretext" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><span class="pretext">You are here:</span> <a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs(pretext: "You are here:").to_s)
    end

    it "posttext" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span> <span class="posttext">text after breadcrumbs</span></div>}, breadcrumbs(posttext: "text after breadcrumbs").to_s)
    end

    it "autoroot disabled" do
      breadcrumb :basic
      assert_dom_equal("", breadcrumbs(autoroot: false).to_s)
    end

    it "separator" do
      breadcrumb :with_root
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &raquo; <span class="current">About</span></div>}, breadcrumbs(separator: " &raquo; ").to_s)
    end

    it "element id" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs" id="custom_id"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs(id: "custom_id").to_s)
    end

    it "custom container class" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="custom_class"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs(class: "custom_class").to_s)
    end

    it "custom fragment class" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a class="custom_fragment_class" href="/">Home</a> &rsaquo; <span class="custom_fragment_class current">About</span></div>}, breadcrumbs(fragment_class: "custom_fragment_class").to_s)
    end

    it "custom current class" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="custom_current_class">About</span></div>}, breadcrumbs(current_class: "custom_current_class").to_s)
    end

    it "custom pretext class" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><span class="custom_pretext_class">You are here:</span> <a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs(pretext: "You are here:", pretext_class: "custom_pretext_class").to_s)
    end

    it "custom posttext class" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span> <span class="custom_posttext_class">after breadcrumbs</span></div>}, breadcrumbs(posttext: "after breadcrumbs", posttext_class: "custom_posttext_class").to_s)
    end

    it "unsafe html" do
      breadcrumb :with_unsafe_html
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test &lt;strong&gt;bold text&lt;/strong&gt;</span></div>}, breadcrumbs.to_s)
    end

    it "safe html" do
      breadcrumb :with_safe_html
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test <strong>bold text</strong></span></div>}, breadcrumbs.to_s)
    end

    it "html_safe?" do
      with_breadcrumb(:with_unsafe_html) do
        expect(breadcrumbs).to be_html_safe
        expect(breadcrumbs.to_s).to be_html_safe
        expect(breadcrumbs(semantic: true).to_s).to be_html_safe
      end

      with_breadcrumb(:with_safe_html) do
        expect(breadcrumbs).to be_html_safe
        expect(breadcrumbs.to_s).to be_html_safe
        expect(breadcrumbs(semantic: true).to_s).to be_html_safe
      end
    end

    it "parent breadcrumb" do
      breadcrumb :multiple_links_with_parent
      parent = parent_breadcrumb
      expect([parent.key, parent.text, parent.url]).to eq [:multiple_links_with_parent, "Contact", "/about/contact"]
    end

    it "yields parent breadcrumb" do
      breadcrumb :multiple_links_with_parent
      out = parent_breadcrumb { |parent| [parent.key, parent.text, parent.url] }
      expect(out).to eq [:multiple_links_with_parent, "Contact", "/about/contact"]
    end

    it "parent breadcrumb returns nil if not present" do
      breadcrumb :basic
      expect(parent_breadcrumb(autoroot: false)).to be_nil
    end

    it "parent breadcrumb yields only if present" do
      breadcrumb :basic
      out = parent_breadcrumb(autoroot: false) do
        "yielded"
      end
      expect(out).to be_nil
    end

    it "link keys" do
      breadcrumb :basic
      expect(breadcrumbs.keys).to eq [:root, :basic]
    end

    it "using breadcrumbs as array" do
      breadcrumb :basic
      breadcrumbs.tap do |links|
        expect(links).to be_a Array
        expect(links.count).to eq 2
      end
    end

    it "sets current on last link in array" do
      breadcrumb :multiple_links_with_parent
      expect(breadcrumbs.map(&:current?)).to eq [false, false, false, true]
    end

    it "passing options to links" do
      breadcrumb :with_link_options

      breadcrumbs(autoroot: false).tap do |links|
        links[0].tap do |link|
          expect(link.title?).to eq true
          expect(link.title).to eq "My Title"
          expect(link.other?).to eq true
          expect(link.other).to eq "Other Option"
          expect(link.nonexistent?).to eq false
          expect(link.nonexistent).to be_nil
        end

        links[1].tap do |link|
          expect(link.some_option?).to eq true
          expect(link.some_option).to eq "Test"
        end
      end

      assert_dom_equal(%{<div class="breadcrumbs"><a href="/about">Test</a> &rsaquo; <span class="current">Other Link</span></div>}, breadcrumbs(autoroot: false).to_s)
    end

    it "without link" do
      breadcrumb :without_link
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; Also without link &rsaquo; <span class="current">Without link</span></div>}, breadcrumbs.to_s)
    end

    it "view context" do
      breadcrumb :using_view_helper
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">TestTest</span></div>}, breadcrumbs.to_s)
    end

    it "multiple arguments" do
      breadcrumb :with_multiple_arguments, "One", "Two", "Three"
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">First OneOne then TwoTwo then ThreeThree</a> &rsaquo; <span class="current">One and Two and Three</span></div>}, breadcrumbs.to_s)
    end

    it "from views folder" do
      breadcrumb :from_views
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Breadcrumb From View</span></div>}, breadcrumbs.to_s)
    end

    it "with_breadcrumb" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs.to_s)

      with_breadcrumb(:with_parent_object, issues(:one)) do
        assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test Issue</span></div>}, breadcrumbs.to_s)
      end

      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs.to_s)
    end

    it "calling breadcrumbs helper twice" do
      breadcrumb :with_parent
      2.times do
        assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Contact</span></div>}, breadcrumbs.to_s)
      end
    end

    it "breadcrumb not found" do
      expect do
        breadcrumb :nonexistent
        breadcrumbs
      end.to raise_error(ArgumentError)
    end

    it "current link url is set to fullpath" do
      self.request = OpenStruct.new(fullpath: "/testpath?a=1&b=2")

      breadcrumb :basic
      expect(breadcrumbs.last.url).to eq "/testpath?a=1&b=2"
    end

    it "current link url is not set to fullpath using link_current_to_request_path=false" do
      self.request = OpenStruct.new(fullpath: "/testpath?a=1&b=2")

      breadcrumb :basic
      expect(breadcrumbs(link_current_to_request_path: false).last.url).to eq "/about"
    end

    it "calling the breadcrumb method with wrong arguments" do
      expect { breadcrumb :basic, test: 1 }.to_not raise_error
      expect { breadcrumb }.to raise_error(ArgumentError)
      expect { breadcrumb pretext: "bla" }.to raise_error(ArgumentError)
    end

    it "inferred breadcrumb" do
      breadcrumb Project.first
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Test Project</span></div>}, breadcrumbs.to_s)
    end

    it "inferred parent" do
      breadcrumb :with_inferred_parent
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/projects/1">Test Project</a> &rsaquo; <span class="current">Test</span></div>}, breadcrumbs.to_s)
    end

    it "conditional branching by crumb_defined?" do
      breadcrumb :home1
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Home1</span></div>}, breadcrumbs.to_s)

      expect do
        breadcrumb :home3
        breadcrumbs
      end.to raise_error(ArgumentError)
    end
  end

  describe 'Styles' do
    it "default style" do
      breadcrumb :basic
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">About</span></div>}, breadcrumbs.to_s)
    end

    it "ordered list style" do
      breadcrumb :basic
      assert_dom_equal(%{<ol class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ol>}, breadcrumbs(style: :ol).to_s)
    end

    it "unordered list style" do
      breadcrumb :basic
      assert_dom_equal(%{<ul class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ul>}, breadcrumbs(style: :ul).to_s)
    end

    it "bootstrap style" do
      breadcrumb :basic
      assert_dom_equal(%{<ol class="breadcrumb"><li><a href="/">Home</a></li><li class="active">About</li></ol>}, breadcrumbs(style: :bootstrap).to_s)
    end

    it "bootstrap4 style" do
      breadcrumb :basic
      assert_dom_equal(%{<ol class="breadcrumb"><li class="breadcrumb-item"><a href="/">Home</a></li><li class="breadcrumb-item active">About</li></ol>}, breadcrumbs(style: :bootstrap4).to_s)
    end

    it "foundation5 style" do
      breadcrumb :basic
      assert_dom_equal(%{<ul class="breadcrumbs"><li><a href="/">Home</a></li><li class="current">About</li></ul>}, breadcrumbs(style: :foundation5).to_s)
    end

    it "custom container and fragment tags" do
      breadcrumb :basic
      assert_dom_equal(%{<c class="breadcrumbs"><f><a href="/">Home</a></f> &rsaquo; <f class="current">About</f></c>}, breadcrumbs(container_tag: :c, fragment_tag: :f).to_s)
    end

    it "custom semantic container and fragment tags" do
      breadcrumb :basic
      assert_dom_equal(%{<c class="breadcrumbs" itemscope="itemscope" itemtype="https://schema.org/BreadcrumbList"><f itemprop="itemListElement" itemscope="itemscope" itemtype="https://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a><meta itemprop="position" content="1" /></f> &rsaquo; <f class="current" itemprop="itemListElement" itemscope="itemscope" itemtype="https://schema.org/ListItem"><span itemprop="name">About</span><meta itemprop="item" content="http://test.host/about" /><meta itemprop="position" content="2" /></f></c>}, breadcrumbs(container_tag: :c, fragment_tag: :f, semantic: true).to_s)
    end

    it "unknown style" do
      breadcrumb :basic
      expect { breadcrumbs(style: :nonexistent) }.to raise_error(ArgumentError)
    end

    it "register style" do
      Gretel.register_style(:test_style, container_tag: :one, fragment_tag: :two)
      breadcrumb :basic
      assert_dom_equal(%{<one class="breadcrumbs"><two><a href="/">Home</a></two><two class="current">About</two></one>}, breadcrumbs(style: :test_style).to_s)
    end
  end

  describe 'Configuration reload' do
    it "reload configuration when file is changed" do
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
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s)

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
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/test">Home (reloaded)</a> &rsaquo; <span class="current">About (reloaded)</span></div>}, breadcrumbs.to_s)
    end

    it "reload configuration when file is added" do
      path = setup_loading_from_tmp_folder
      Gretel.reload_environments << "test"

      File.open(path.join("site.rb"), "w") do |f|
        f.write <<-EOT
          crumb :root do
            link "Home (loaded)", root_path
          end
        EOT
      end

      expect do
        breadcrumb :about
        breadcrumbs
      end.to raise_error(ArgumentError)

      File.open(path.join("pages.rb"), "w") do |f|
        f.write <<-EOT
          crumb :about do
            link "About (loaded)", about_path
          end
        EOT
      end

      breadcrumb :about
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s)
    end

    it "reload configuration when file is deleted" do
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
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <a href="/about">About (loaded)</a> &rsaquo; <span class="current">Contact (loaded)</span></div>}, breadcrumbs.to_s)

      File.delete(path.join("pages.rb"))

      expect do
        breadcrumb :contact
        breadcrumbs
      end.to raise_error(ArgumentError)

      breadcrumb :about
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s)
    end

    it "reloads only in development environment" do
      path = setup_loading_from_tmp_folder
      expect(Gretel.reload_environments).to eq ["development"]

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
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s)

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
      assert_dom_equal(%{<div class="breadcrumbs"><a href="/">Home (loaded)</a> &rsaquo; <span class="current">About (loaded)</span></div>}, breadcrumbs.to_s)
    end
  end

  describe 'Structured data' do
    # https://developers.google.com/search/docs/data-types/breadcrumb#year-genre%20example
    it "returns an object with the correct structure" do
      breadcrumb :with_parent

      expected_result = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
          {
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://example.com/"
          },
           {
            "@type": "ListItem",
            "position": 2,
            "name": "About",
            "item": "https://example.com/about"
          },
           {
            "@type": "ListItem",
            "position": 3,
            "name": "Contact",
            "item": "https://example.com/about/contact"
          }
        ]
      }

      expect(breadcrumbs.structured_data(url_base: "https://example.com")).to eq(expected_result)
      # Ensure there's no extra trailing slashes
      expect(breadcrumbs.structured_data(url_base: "https://example.com/")).to eq(expected_result)
    end
  end

  private

  def setup_loading_from_tmp_folder
    path = Rails.root.join("tmp", "testcrumbs")
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
    Gretel.breadcrumb_paths = [path.join("*.rb")]
    path
  end
end
