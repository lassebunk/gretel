require 'test_helper'
require 'fakeredis'

class RedisStoreTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
    Gretel::Trail.store = :redis
    
    @links = [
      [:root, "Home", "/"],
      [:store, "Store <b>Test</b>".html_safe, "/store"],
      [:search, "Search", "/store/search?q=test"]
    ]
  end

  test "defaults" do
    assert_equal 1.day, Gretel::Trail::RedisStore.expires_in
  end

  test "encoding" do
    assert_equal "684c211441e72225cee89477a2d1f59e657c9e26",
                 Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
    decoded = Gretel::Trail.decode("684c211441e72225cee89477a2d1f59e657c9e26")
    assert_equal @links, decoded.map { |link| [link.key, link.text, link.url] }
    assert_equal [false, true, false], decoded.map { |link| link.text.html_safe? }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trail.decode("asdgasdg")
  end
end