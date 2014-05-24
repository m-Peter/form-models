module FormObject
  module Populator
    class RootPopulator
      attr_reader :model, :association_name, :pending_attributes

      def initialize(args={})
        @model = args[:model]
        @association_name = args[:association_name]
        @pending_attributes = args[:attrs]
      end

      def call
        populate_model_attributes(model, pending_attributes)
      end

      def populate_model_attributes(model, attributes)
        model.attributes = attributes
      end
    end
  end
end