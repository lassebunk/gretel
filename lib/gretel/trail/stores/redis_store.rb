module Gretel
  module Trail
    class RedisStore < Store
      class << self
        # Options to connect to Redis.
        def connect_options
          @connect_options ||= {}
        end

        # Sets the Redis connect options.
        attr_writer :connect_options

        # Number of seconds to keep the trails in Redis.
        # Default: +1.day+
        def expires_in
          @expires_in ||= 1.day
        end

        # Sets the number of seconds to keep the trails in Redis.
        attr_writer :expires_in

        # Save array to Redis.
        def save(array)
          json = array.to_json
          key = Digest::SHA1.hexdigest(json)
          redis.setex redis_key_for(key), expires_in, json
          key
        end

        # Retrieve array from Redis.
        def retrieve(key)
          if json = redis.get(redis_key_for(key))
            JSON.parse(json)
          end
        end

        # Reference to the Redis connection.
        def redis
          @redis ||= begin
            raise "Redis needs to be installed in order for #{name} to use it. Please add `gem \"redis\"` to your Gemfile." unless defined?(Redis)
            Redis.new(connect_options)
          end
        end

        private

        # Key to be stored in Redis.
        def redis_key_for(key)
          "gretel:trail:#{key}"
        end
      end
    end
  end
end