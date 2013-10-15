module Gretel
  module Trail
    class Store
      class << self
        # Encode array of +links+ to unique trail key.
        def encode(links)
          raise "#{name} must implement #encode to be able to encode trails."
        end

        # Decode unique trail key to array of links.
        def decode(key)
          raise "#{name} must implement #decode to be able to decode trails."
        end
    
        # Resets all changes made to the store. Used for testing.
        def reset!
          instance_variables.each { |var| remove_instance_variable var }
        end
      end
    end
  end
end