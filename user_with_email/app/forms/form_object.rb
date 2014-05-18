require "form_object/model_factory"

module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    attr_reader :factory
    delegate :to_key, :id, :to_param, :persisted?, :to_model, to: :main_model

    def self.model_name
      User.model_name
    end

    def initialize(attributes={})
      assign_from_hash(attributes)
    end

    def submit(params)
      @factory = ModelFactory.new(main_model, params)
      @factory.populate_model
    end

    def save
      ActiveRecord::Base.transaction do
        @factory.save!
      end
    end

    def main_model
      send(self.class.root_model)
    end

    class << self
      def root_model=(model)
        @root_model = model
      end

      def root_model
        @root_model
      end

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

    def each_models
      self.class.models.each do |model_name|
        yield(send(model_name))
      end
    end

    def call_action(action)
      each_models(&action)
    end

  end
end