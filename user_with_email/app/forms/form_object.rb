module FormObject
  class Base
    def self.attribute(attribute)
      attr_accessor(attribute)
    end
  end
end