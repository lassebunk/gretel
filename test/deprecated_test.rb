require 'test_helper'

class DeprecatedTest < ActionView::TestCase
  include Gretel::ViewHelpers
  fixtures :all
  helper :application

  setup do
    Gretel.reset!
  end

  test "deprecated configuration block" do
    assert_raises RuntimeError do
      Gretel::Crumbs.layout do
      end
    end
  end
end