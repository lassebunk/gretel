module Gretel
  module Resettable
    def reset!
      instance_variables.each { |var| remove_instance_variable var }
    end
  end
end