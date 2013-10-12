module Gretel
  module Trail
    class << self
      # Secret used for crypting trail in URL that should be set to something
      # unguessable. This is required when using trails, for the reason that
      # unencrypted trails would be vulnerable to cross-site scripting attacks.
      attr_accessor :secret

      # Securely encodes array of links to a trail string to be used in URL.
      def encode(links)
        ensure_secret!

        base64 = encode_base64(links)
        hash = base64.crypt(secret)

        [hash, base64].join("_")
      end

      # Securely decodes a URL trail string to array of links.
      def decode(trail)
        ensure_secret!

        hash, base64 = trail.split("_", 2)

        if base64.blank?
          Rails.logger.info "[Gretel] Trail decode failed: No Base64 in trail"
          []
        elsif hash == base64.crypt(secret)
          decode_base64(base64)
        else
          Rails.logger.info "[Gretel] Trail decode failed: Invalid hash '#{hash}' in trail"
          []
        end
      end

      # Name of trail param. Default: +:trail+.
      def trail_param
        @trail_param ||= :trail
      end
      
      attr_writer :trail_param

      # Resets all changes made to +Gretel::Trail+. Used for testing.
      def reset!
        instance_variables.each { |var| remove_instance_variable var }
      end

    private

      # Encodes links array to Base64, internally using JSON for serialization.
      def encode_base64(links)
        arr = links.map { |link| [link.key, link.text, link.url] }
        Base64.urlsafe_encode64(arr.to_json)
      end

      # Decodes links array from Base64.
      def decode_base64(base64)
        json = Base64.urlsafe_decode64(base64)
        arr = JSON.parse(json)
        arr.map { |key, text, url| Link.new(key, text, url) }
      rescue
        Rails.logger.info "[Gretel] Trail decode failed: Invalid Base64 '#{base64}' in trail"
        []
      end

      # Ensures that a secret has been set, and raises an exception if this is not the case.
      def ensure_secret!
        raise "Gretel::Trail.secret is not set. Please set it to an unguessable string, e.g. from `rake secret`, or use `rails generate gretel:install` to generate and set it automatically." if secret.blank?
      end

    end
  end
end