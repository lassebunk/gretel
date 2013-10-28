module Gretel
  module Resettable
    # Resets all instance variables and calls +reset!+ on all child modules and
    # classes. Used for testing.
    def reset!
      instance_variables.each { |var| remove_instance_variable var }
      constants.each do |c|
        c = const_get(c)
        c.reset! if c.respond_to?(:reset!)
      end
    end
  end
end