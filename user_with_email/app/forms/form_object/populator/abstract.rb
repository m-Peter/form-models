module FormObject
  module Populator
    class Abstract
      attr_reader :model, :association_name, :pending_attributes

      def initialize(args={})
        @model = args[:model]
        @association_name = args[:association_name]
        @pending_attributes = args[:pending_attributes]
      end

      def call
        populate_model_attributes(model, pending_attributes)

        if model.new_record?
          assign_to_parent
        end
      end

      protected

      def assign_to_parent
        raise NotImplementedError, "You have to implement this in your subclass"
      end

      def populate_model_attributes(model, attributes)
        populate_individual_record(model, attributes)
      end

      def populate_individual_record(record, attrs)
        record.attributes = record.attributes.merge(attrs)
      end
    end
  end
end