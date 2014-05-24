module FormObject
  class ModelFactory
    attr_reader :attributes, :model

    def initialize(attributes)
      @attributes = attributes
    end

    def populate_model
      @model = create_root_model

      root_populator = FormObject::Populator::RootPopulator.new(root_populator_args)
      root_populator.call

      @model
    end

    def root_populator_args
      ActiveSupport::HashWithIndifferentAccess.new(
        model: model,
        attrs: params_for_current_scope(attributes.values.first),
        association_name: attributes.keys.first
      )
    end

    def params_for_current_scope(attrs)
      attrs.dup.reject { |_, v| v.is_a?(Hash) }
    end

    def create_root_model
      model_class = attributes.keys.first.to_s.camelize.constantize
      model_class.new
    end
  end
end