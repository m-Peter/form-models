module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    class << self
      def attributes(*names)
        attr_accessor *names
      end

      alias_method :attribute, :attributes
    end

  end
end