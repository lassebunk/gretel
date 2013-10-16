module Gretel
  module Trail
    class Store
      class << self
        # Save an encoded array to the store. It must return the trail key that
        # can later be used to retrieve the array from the store.
        def save(array)
          raise "#{name} must implement #save to be able to save trails."
        end

        # Retrieve an encoded array from the store based on the saved key.
        # It must return either the array, or nil if the key was not found.
        def retrieve(key)
          raise "#{name} must implement #retrieve to be able to retrieve trails."
        end

        # Deletes expired keys from the store.
        def delete_expired
          raise "#{name} doesn't support deleting expired keys."
        end

        # Gets the number of stored trail keys.
        def key_count
          raise "#{name} doesn't support counting trail keys."
        end

        # Encode array of +links+ to unique trail key.
        def encode(links)
          arr = links.map { |link| [link.key, link.text, (link.text.html_safe? ? 1 : 0), link.url] }
          save(arr)
        end

        # Decode unique trail key to array of links.
        def decode(key)
          if arr = retrieve(key)
            arr.map { |key, text, html_safe, url| Link.new(key.to_sym, (html_safe == 1 ? text.html_safe : text), url) }
          else
            []
          end
        end
    
        # Resets all changes made to the store. Used for testing.
        def reset!
          instance_variables.each { |var| remove_instance_variable var }
        end
      end
    end
  end
end