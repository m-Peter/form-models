module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    delegate :to_key, :id, :to_param, :persisted?, :to_model, to: :main_model

    def initialize(attributes={})
      assign_from_hash(attributes)
    end

    def submit(params)
      assign_from_hash(params)
    end

    def save
      ActiveRecord::Base.transaction do
        call_action(:save!)
      end
    end

    def main_model
      if self.class.main_model.kind_of?(Symbol)
        send(self.class.main_model)
      else
        self.class.main_model
      end
    end

    class << self
      attr_accessor :main_class, :main_model

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

      def main_model
        @main_model ||= self
      end

      def main_class
        @main_class ||= if main_model.kind_of?(Symbol)
          main_model.to_s.camelize.constantize
        else
          @main_model
        end
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