require "gretel/trail/url_store"
require "gretel/trail/redis_store"

module Gretel
  module Trail
    STORES = {
      url: UrlStore,
      redis: RedisStore
    }

    class << self
      # Gets the store that is used to encode and decode trails.
      # Default: +Gretel::Trail::UrlStore+
      def store
        @store ||= UrlStore
      end

      # Sets the store that is used to encode and decode trails.
      # Can be a subclass of +Gretel::Trail::Store+, or a symbol: +:url+.
      def store=(value)
        if value.is_a?(Symbol)
          klass = STORES[value]
          raise ArgumentError, "Unknown Gretel::Trail.store #{value.inspect}. Use any of #{STORES.inspect}." unless klass
          self.store = klass
        else
          @store = value
        end
      end

      # Uses the store to encode an array of links to a unique key that can be used in URLs.
      def encode(links)
        store.encode(links)
      end

      # Uses the store to decode a unique key to an array of links.
      def decode(key)
        store.decode(key)
      end

      # Name of trail param. Default: +:trail+.
      def trail_param
        @trail_param ||= :trail
      end
      
      attr_writer :trail_param

      # Resets all changes made to +Gretel::Trail+. Used for testing.
      def reset!
        instance_variables.each { |var| remove_instance_variable var }
        STORES.each_value(&:reset!)
      end
    end
  end
end