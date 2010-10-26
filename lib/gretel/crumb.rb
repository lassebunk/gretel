module Gretel
  class Crumb
    attr_accessor :link, :parent
    
    def initialize(link, parent)
      @link, @parent = link, parent
    end
  end
end