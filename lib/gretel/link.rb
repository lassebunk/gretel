module Gretel
  class Link
    attr_accessor :key, :text, :url

    def initialize(key, text, url)
      @key, @text, @url = key, text, url
    end
  end
end