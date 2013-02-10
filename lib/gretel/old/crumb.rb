module Gretel
  class Crumb
    attr_accessor :links, :parent
    
    def initialize(links, parent)
      @links, @parent = links, parent
    end
  end
end