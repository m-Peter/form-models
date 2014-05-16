module FormObject
  class Base
    class << self
      def attributes(*attributes)
        attr_accessor(*attributes)
      end
      alias_method :attribute, :attributes
    end
  end
end