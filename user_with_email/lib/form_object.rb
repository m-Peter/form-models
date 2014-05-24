module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    def initialize(models={})
      assign_from_hash(models)
    end

    def submit(params)
      params.each do |key, value|
        send("#{key}=", value)
      end

      #valid?
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

    def root_model
      send(self.class.root_model)
    end

    def persisted?
      root_model.persisted?
    end

    def to_key
      return nil unless persisted?
      root_model.id
    end

    def to_model
      root_model
    end

    def to_param
      return nil unless persisted?
      root_model.id.to_s
    end

    private

      def assign_from_hash(hash)
        hash.each do |key, value|
          add_model_on_list(value)
          send("#{key}=", value)
        end
      end

      def models
        @models ||= []
      end

      def add_model_on_list(model)
        models << model
      end

    class << self
      def root_model=(model)
        @@root_model = model
      end

      def root_model
        @@root_model
      end

      def attributes(*names, of: nil)
        if of.nil?
          attr_accessor *names
        else
          delegate_to_model(names, of)
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

    end

  end
end