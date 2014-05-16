module FormObject
  class Base

    def initialize(attributes={})
      assign_from_hash(attributes)
    end

    class << self
      def attributes(*attributes, of: nil)
        if of.nil?
          attr_accessor(*attributes)
        else
          delegate_to_model(attributes, of)
        end
      end

      alias_method :attribute, :attributes

      def models
        @models ||= []
      end

      private

      def delegate_to_model(attributes, of)
        assign_delegators(attributes, of)
        add_model_on_list(of)
        add_accessor(of)
      end

      def add_model_on_list(model_name)
        models << model_name unless models.include?(model_name)
      end

      def assign_delegators(attributes, model_name)
        attributes.each do |attribute|
          delegate attribute, to: model_name
          delegate "#{attribute}=", to: model_name
        end
      end

      def add_accessor(model_name)
        attr_accessor model_name
      end
    end

    private

    def assign_from_hash(hash)
      hash.each { |key, value| send("#{key}=", value) }
    end

  end
end