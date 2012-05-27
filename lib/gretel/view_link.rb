module Gretel
  class ViewLink
    attr_reader :text, :url, :options, :current
    
    def initialize(text, url, options, current = false)
      @text, @url, @options, @current = text, url, options, current
    end
    
    def current?
      current
    end
  end
end