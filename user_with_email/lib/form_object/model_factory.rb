module FormObject
  class ModelFactory
    attr_reader :attributes, :model

    def initialize(attributes)
      @attributes = attributes
    end

    def populate_model
      @model = create_root_model
    end

    def create_root_model
      model_class = attributes.keys.first.to_s.camelize.constantize
      model_class.new
    end
  end
end