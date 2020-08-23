require("spec_helper")
RSpec.describe(Gretel) do
  before { Gretel.reset! }
  it("defaults") do
    expect(Gretel.breadcrumb_paths[(-3..-1)]).to(eq([Rails.root.join("config", "breadcrumbs.rb"), Rails.root.join("config", "breadcrumbs", "**", "*.rb"), Rails.root.join("app", "views", "breadcrumbs", "**", "*.rb")]))
    expect(Gretel.reload_environments).to(eq(["development"]))
  end
  it("configuration block") do
    Gretel.configure { |config| (config.reload_environments << "staging") }
    expect(Gretel.reload_environments).to(eq(["development", "staging"]))
  end
end
