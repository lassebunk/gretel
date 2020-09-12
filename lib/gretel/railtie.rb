require 'gretel/view_helpers'

module Gretel
  class Railtie < ::Rails::Railtie
    initializer 'gretel.view_helpers' do
      ActiveSupport.on_load(:action_view) do
        include ViewHelpers
      end
    end
  end
end
