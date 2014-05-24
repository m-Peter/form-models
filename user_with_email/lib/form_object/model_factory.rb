module FormObject
  class ModelFactory
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end
end