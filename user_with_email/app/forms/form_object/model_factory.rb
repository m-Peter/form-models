module FormObject
  class ModelFactory
    attr_reader :attributes, :records_to_save, :model

    def initialize(attributes)
      @attributes = attributes
      @records_to_save = []
    end

    def populate_model
      @model = create_root_model
    end

    private

    def create_root_model
      model_class = attributes.keys.first.to_s.camelize.constantize
      model_class.new
    end
  end
end