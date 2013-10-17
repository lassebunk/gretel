require 'test_helper'

class TrailTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
  end

  test "defaults" do
    assert_equal :trail, Gretel::Trail.trail_param
  end

  test "setting invalid store" do
    assert_raises ArgumentError do
      Gretel::Trail.store = :xx
    end
  end

  test "setting store options on main module" do
    assert_equal :trail, Gretel.trail_param
    Gretel.trail_param = :other_param
    assert_equal :other_param, Gretel::Trail.trail_param

    assert_equal Gretel::Trail::UrlStore, Gretel.trail_store
    Gretel.trail_store = :redis
    assert_equal Gretel::Trail::RedisStore, Gretel::Trail.store
  end
end