module Gretel
  class Link
    attr_accessor :options, :text, :url
    
    def initialize(text, url, options = {})
      @text, @url, @options = text, url, options
    end
  end
end