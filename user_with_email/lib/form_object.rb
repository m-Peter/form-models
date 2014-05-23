module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    def initialize(models={})
      assign_from_hash(models)
    end

    def assign_from_hash(hash)
      hash.each { |key, value| send("#{key}=", value) }
    end

    class << self
      def attributes(*names, of: nil)
        if of.nil?
          attr_accessor *names
        else
          names.each do |attribute|
            delegate attribute, to: of
            delegate "#{attribute}=", to: of
          end
          attr_accessor of
        end
      end

      alias_method :attribute, :attributes
    end

  end
end