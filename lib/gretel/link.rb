module Gretel
  class Link
    attr_accessor :text, :url
    
    def initialize(text, url)
      @text, @url = text, url
    end
  end
end