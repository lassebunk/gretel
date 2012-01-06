module Gretel
  class Parent
    attr_accessor :name, :object
    
    def initialize(name, object)
      @name, @object = name, object
    end
  end
end