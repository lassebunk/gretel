module Gretel
  module Trail
    class ActiveRecordStore < Store
      class << self
        # Number of seconds to keep the trails in the database.
        # Default: +1.day+
        def expires_in
          @expires_in ||= 1.day
        end

        # Sets the number of seconds to keep the trails in the database.
        attr_writer :expires_in

        # Save array to database.
        def save(array)
          json = array.to_json
          key = Digest::SHA1.hexdigest(json)
          GretelTrail.set(key, array, expires_in.from_now)
          key
        end

        # Retrieve array from database.
        def retrieve(key)
          GretelTrail.get(key)
        end

        # Delete expired keys.
        def delete_expired
          GretelTrail.delete_expired
        end

        # Gets the number of trails stored in the database.
        def key_count
          GretelTrail.count
        end
      end
      
      class GretelTrail < ActiveRecord::Base
        serialize :value, Array

        def self.get(key)
          find_by_key(key).try(:value)
        end

        def self.set(key, value, expires_at)
          find_or_initialize_by_key(key).tap do |rec|
            rec.value = value
            rec.expires_at = expires_at
            rec.save
          end
        end

        def self.delete_expired
          delete_all(["expires_at < ?", Time.now])
        end
      end
    end
  end
end