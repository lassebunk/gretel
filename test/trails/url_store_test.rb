require 'test_helper'

class UrlStoreTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
    
    Gretel::Trail.store = :url
    Gretel::Trail::UrlStore.secret = "128107d341e912db791d98bbe874a8250f784b0a0b4dbc5d5032c0fc1ca7bda9c6ece667bd18d23736ee833ea79384176faeb54d2e0d21012898dde78631cdf1"
    
    @links = [
      [:root, "Home", "/"],
      [:store, "Store <b>Test</b>".html_safe, "/store"],
      [:search, "Search", "/store/search?q=test"]
    ]
  end

  test "encoding" do
    assert_equal "5543214e6d7bbc3ba5209b2362cd7513d500f61b_W1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUgPGI-VGVzdDwvYj4iLDEsIi9zdG9yZSJdLFsic2VhcmNoIiwiU2VhcmNoIiwwLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==",
                 Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    decoded = Gretel::Trail.decode("5543214e6d7bbc3ba5209b2362cd7513d500f61b_W1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUgPGI-VGVzdDwvYj4iLDEsIi9zdG9yZSJdLFsic2VhcmNoIiwiU2VhcmNoIiwwLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==")
    assert_equal @links, decoded.map { |link| [link.key, link.text, link.url] }
    assert_equal [false, true, false], decoded.map { |link| link.text.html_safe? }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trail.decode("28f104524f5eaf6b3bd035710432fd2b9cbfd62c_X1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUiLDAsIi9zdG9yZSJdLFsic2VhcmNoIiwiU2VhcmNoIiwwLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==")
  end

  test "raises error if no secret set" do
    Gretel::Trail::UrlStore.secret = nil
    assert_raises RuntimeError do
      Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
    end
  end
end