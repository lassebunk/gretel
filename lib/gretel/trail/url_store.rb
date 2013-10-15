require "gretel/trail/store"

module Gretel
  module Trail
    class UrlStore < Store
      class << self
        # Secret used for crypting trail in URL that should be set to something
        # unguessable. This is required when using trails, for the reason that
        # unencrypted trails would be vulnerable to cross-site scripting attacks.
        attr_accessor :secret

        # Securely encodes array of links to a trail string to be used in URL.
        def encode(links)
          base64 = encode_base64(links)
          hash = generate_hash(base64)

          [hash, base64].join("_")
        end

        # Securely decodes a URL trail string to array of links.
        def decode(key)
          hash, base64 = key.split("_", 2)

          if base64.blank?
            Rails.logger.info "[Gretel] Trail decode failed: No Base64 in trail"
            []
          elsif hash == generate_hash(base64)
            decode_base64(base64)
          else
            Rails.logger.info "[Gretel] Trail decode failed: Invalid hash '#{hash}' in trail"
            []
          end
        end

        private

        # Encodes links array to Base64, internally using JSON for serialization.
        def encode_base64(links)
          arr = links.map { |link| [link.key, link.text, (link.text.html_safe? ? 1 : 0), link.url] }
          Base64.urlsafe_encode64(arr.to_json)
        end

        # Decodes links array from Base64.
        def decode_base64(base64)
          json = Base64.urlsafe_decode64(base64)
          arr = JSON.parse(json)
          arr.map { |key, text, html_safe, url| Link.new(key.to_sym, (html_safe == 1 ? text.html_safe : text), url) }
        rescue
          Rails.logger.info "[Gretel] Trail decode failed: Invalid Base64 '#{base64}' in trail"
          []
        end

        # Generates a salted hash of +base64+.
        def generate_hash(base64)
          raise "#{name}.secret is not set. Please set it to an unguessable string, e.g. from `rake secret`, or use `rails generate gretel:install` to generate and set it automatically." if secret.blank?
          Digest::SHA1.hexdigest([base64, secret].join)
        end
      end
    end
  end
end