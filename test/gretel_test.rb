require 'test_helper'

class GretelTest < ActiveSupport::TestCase
  test "initializer should work" do
    assert_respond_to Gretel::Crumbs, :layout
  end
end
