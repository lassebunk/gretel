require 'test_helper'

class GretelTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
  end

  test "defaults" do
    assert_equal [Rails.root.join("config", "breadcrumbs.rb"), Rails.root.join("config", "breadcrumbs", "**", "*.rb")],
                 Gretel.breadcrumb_paths
    assert_equal ["development"], Gretel.reload_environments
    assert !Gretel.suppress_deprecation_warnings?
  end

  test "configuration block" do
    Gretel.configure do |config|
      config.trail_param = :other_param
    end

    assert_equal :other_param, Gretel.trail_param
  end
end