require 'test_helper'

class ActiveRecordStoreTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
    Gretel::Trail.store = :db
    
    @links = [
      [:root, "Home", "/"],
      [:store, "Store <b>Test</b>".html_safe, "/store"],
      [:search, "Search", "/store/search?q=test"]
    ]
  end

  test "defaults" do
    assert_equal 1.day, Gretel::Trail::ActiveRecordStore.expires_in
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

  test "delete expired" do
    10.times { Gretel::Trail.encode([Gretel::Link.new(:test, SecureRandom.hex(20), "/test")]) }
    assert_equal 10, Gretel::Trail.count
    
    Gretel::Trail.delete_expired
    assert_equal 10, Gretel::Trail.count

    Timecop.travel(14.hours.from_now) do
      5.times { Gretel::Trail.encode([Gretel::Link.new(:test, SecureRandom.hex(20), "/test")]) }
      assert_equal 15, Gretel::Trail.count
    end

    Timecop.travel(25.hours.from_now) do
      Gretel::Trail.delete_expired
      assert_equal 5, Gretel::Trail.count
    end
  end
end