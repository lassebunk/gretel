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
    assert_equal "12hY7tdmRCBzQ_LS0tCi0gLSByb290CiAgLSBIb21lCiAgLSAvCi0gLSBzdG9yZQogIC0gU3RvcmUKICAtIC9zdG9yZQotIC0gc2VhcmNoCiAgLSBTZWFyY2gKICAtIC9zdG9yZS9zZWFyY2g_cT10ZXN0Cg==",
                 Gretel::Trail.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    assert_equal @links,
                 Gretel::Trail.decode("12hY7tdmRCBzQ_LS0tCi0gLSByb290CiAgLSBIb21lCiAgLSAvCi0gLSBzdG9yZQogIC0gU3RvcmUKICAtIC9zdG9yZQotIC0gc2VhcmNoCiAgLSBTZWFyY2gKICAtIC9zdG9yZS9zZWFyY2g_cT10ZXN0Cg==").map { |link| [link.key, link.text, link.url] }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trail.decode("12hY7tdmRCBzZ_LS0tCi0gLSByb290CiAgLSBIb21lCiAgLSAvCi0gLSBzdG9yZQogIC0gU3RvcmUKICAtIC9zdG9yZQotIC0gc2VhcmNoCiAgLSBTZWFyY2gKICAtIC9zdG9yZS9zZWFyY2g_cT10ZXN0Cc==")
  end
end