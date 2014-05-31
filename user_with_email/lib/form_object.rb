module FormObject
  class Base
    include ActiveModel::Model

    attr_reader :factory

    def initialize(models={})
      assign_from_hash(models)
    end

    def submit(params)
      name = self.class.root_model
      @factory = ModelFactory.new(@user, params.slice(name))
      @factory.populate_model
      assign_from_hash(@factory.models)
    end

    def save
      ActiveRecord::Base.transaction do
        @factory.save!
      end
    end

    def valid?
      result = super
      models = @factory.models.values
      
      result &= validate_models(models)

      collect_errors_from(models)

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

    def self.model_name
      ActiveModel::Name.new(root_model.to_s.camelize.constantize)
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

      private

        def delegate_to_model(attributes, of)
          assign_delegators(attributes, of)
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
    end

    private
    
    def assign_from_hash(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def collect_errors_from(models)
      models.each do |model|
        model.errors.each do |attribute, error|
          errors.add(attribute, error)
        end
      end
    end

    def validate_models(models)
      models.each do |model|
        return false unless model.valid?
      end

      true
    end

  end
end