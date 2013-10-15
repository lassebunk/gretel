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
end