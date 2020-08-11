require 'test_helper'

class GretelTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
  end

  test "defaults" do
    assert_equal [Rails.root.join("config", "breadcrumbs.rb"),
                  Rails.root.join("config", "breadcrumbs", "**", "*.rb"),
                  Rails.root.join("app", "views", "breadcrumbs", "**", "*.rb")],
                 Gretel.breadcrumb_paths[-3..-1]
    assert_equal ["development"], Gretel.reload_environments
    assert !Gretel.suppress_deprecation_warnings?
  end

  test "configuration block" do
    Gretel.configure do |config|
      config.reload_environments << "staging"
    end

    assert_equal ["development", "staging"], Gretel.reload_environments
  end
end