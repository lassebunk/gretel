require "gretel/trail/stores"
require "gretel/trail/tasks"

module Gretel
  module Trail
    STORES = {
      url: UrlStore,
      db: ActiveRecordStore,
      redis: RedisStore
    }

    class << self
      # Gets the store that is used to encode and decode trails.
      # Default: +Gretel::Trail::UrlStore+
      def store
        @store ||= UrlStore
      end

      # Sets the store that is used to encode and decode trails.
      # Can be a subclass of +Gretel::Trail::Store+, or a symbol: +:url+, +:db+, or +:redis+.
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

      # Deletes expired keys from the store.
      # Not all stores support expiring keys, and will raise an exception if they don't.
      def delete_expired
        store.delete_expired
      end

      # Returns the current number of trails in the store.
      # Not all stores support counting keys, and will raise an exception if they don't.
      def count
        store.key_count
      end

      # Name of trail param. Default: +:trail+.
      def trail_param
        @trail_param ||= :trail
      end
      
      # Sets the trail param.
      attr_writer :trail_param

      # Resets all changes made to +Gretel::Trail+. Used for testing.
      def reset!
        instance_variables.each { |var| remove_instance_variable var }
        STORES.each_value(&:reset!)
      end
    end
  end
end