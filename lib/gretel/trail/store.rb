module Gretel
  module Trail
    class Store
      # Encode array of +links+ to unique trail key.
      def self.encode(links)
        raise "#{self.name} must implement #encode to be able to encode trails."
      end

      # Decode unique trail key to array of links.
      def self.decode(key)
        raise "#{self.name} must implement #decode to be able to decode trails."
      end
  
      # Resets all changes made to the store. Used for testing.
      def self.reset!
        instance_variables.each { |var| remove_instance_variable var }
      end
    end
  end
end