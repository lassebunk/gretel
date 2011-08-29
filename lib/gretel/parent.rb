module Gretel
  class Parent
    attr_accessor :name, :params
    
    def initialize(name, *params)
      @name, @params = name, params
    end
  end
end