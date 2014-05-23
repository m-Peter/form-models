module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    def initialize(models={})
      @models ||= []
      assign_from_hash(models)
    end

    def assign_from_hash(hash)
      hash.each do |key, value|
        @models << value unless @models.include?(value)
        send("#{key}=", value)
      end
    end

    def submit(params)
      params.each do |key, value|
        send("#{key}=", value)
      end

      valid?
    end

    def valid?
      result = super
      
      @models.each do |model|
        result &= model.valid?
      end

      @models.each do |model|
        model.errors.each do |attribute, error|
          errors.add(attribute, error)
        end
      end

      result
    end

    class << self
      def attributes(*names, of: nil)
        if of.nil?
          attr_accessor *names
        else
          delegate_to_model(names, of)
        end
      end

      def delegate_to_model(attributes, of)
        assign_delegators(attributes, of)
        add_model_on_list(of)
        add_accessor(of)
      end

      def add_accessor(model_name)
        attr_accessor model_name
      end

      def assign_delegators(attributes, model_name)
        attributes.each do |attribute|
          delegate attribute, to: model_name
          delegate "#{attribute}=", to: model_name
        end
      end

      def add_model_on_list(model_name)
        models << model_name unless models.include?(model_name)
      end

      def models
        @models ||= []
      end

      alias_method :attribute, :attributes
    end

  end
end