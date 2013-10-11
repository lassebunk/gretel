require 'test_helper'

class TrailTest < ActiveSupport::TestCase
  setup do
    Gretel::Trail.secret = "128107d341e912db791d98bbe874a8250f784b0a0b4dbc5d5032c0fc1ca7bda9c6ece667bd18d23736ee833ea79384176faeb54d2e0d21012898dde78631cdf1"
    @links = [
      ["root", "Home", "/"],
      ["store", "Store", "/store"],
      ["search", "Search", "/store/search?q=test"]
    ]
  end

  test "defaults" do
    assert_equal :trail, Gretel::Trail.trail_param
  end

  test "encoding" do
    assert_equal "122.5Th13fvkg_W1sicm9vdCIsIkhvbWUiLCIvIl0sWyJzdG9yZSIsIlN0b3JlIiwiL3N0b3JlIl0sWyJzZWFyY2giLCJTZWFyY2giLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==",
                 Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    assert_equal @links,
                 Gretel::Trail.decode("122.5Th13fvkg_W1sicm9vdCIsIkhvbWUiLCIvIl0sWyJzdG9yZSIsIlN0b3JlIiwiL3N0b3JlIl0sWyJzZWFyY2giLCJTZWFyY2giLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==").map { |link| [link.key, link.text, link.url] }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trail.decode("122.5Th13fvkg_X1sicm9vdCIsIkhvbWUiLCIvIl0sWyJzdG9yZSIsIlN0b3JlIiwiL3N0b3JlIl0sWyJzZWFyY2giLCJTZWFyY2giLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==")
  end
end