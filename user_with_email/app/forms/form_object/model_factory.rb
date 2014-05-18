module FormObject
  class ModelFactory
    attr_reader :attributes, :records_to_save, :model

    def initialize(model, attributes)
      @attributes = attributes
      @records_to_save = []
      @model = model
    end

    def populate_model
      #@model = create_root_model

      populators = [Populator::Root.new(root_populator_args)]
      populators.concat(
        create_populators_for(model, attributes.values.first).flatten
      )

      populators.each do |p|
        p.call
      end

      @model
    end

    def root_populator_args
      root_populator_args = {
        :model => model,
        :attrs => params_for_current_scope(attributes.values.first),
        :association_name => attributes.keys.first
      }
    end

    def save!
      model.save!
      records_to_save.each(&:save!)
    end

    def create_populators_for(model, attributes)
      attributes.each_with_object([]) do |key_value, association_populators|
        next unless key_value[1].is_a?(Hash)

        key, value       = key_value
        macro            = macro_for_attribute_key(key)
        associated_attrs =
          case macro
          when :has_many
            value.values
          when :has_one
            [value]
          end

        associated_attrs.inject(association_populators) do |populators, record_attrs|
          assoc_name = find_association_name_in(key)
          current_scope_attrs = params_for_current_scope(record_attrs)

          associated_model = find_or_initialize_associated_model(
            current_scope_attrs,
            :for_association_name => assoc_name,
            :on_model             => model,
            :with_macro           => macro
          )

          populator_class = "FormObject::Populator::#{macro.to_s.camelize}".constantize

          populator_args = {
            :model                => associated_model,
            :association_name     => assoc_name,
            :attrs                => current_scope_attrs,
            :parent               => model
          }

          populators << populator_class.new(populator_args)
          populators.concat(
            create_populators_for(associated_model, record_attrs)
          )
        end
      end
    end

    def find_or_initialize_associated_model(attrs, args = {})
      association_name, macro, model = args.values_at(:for_association_name, :with_macro, :on_model)

      association = model.send(association_name)
      if attrs[:id]
        find_associated_model(
          attrs,
          :on_model => model,
          :with_macro => macro,
          :on_association => association
        ).tap do |record|
          records_to_save << record
        end
      else
        case macro
        when :has_many
          model.send(association_name).build
        when :has_one
          model.send("build_#{association_name}")
        end
      end
    end

    def macro_for_attribute_key(key)
      association_name = find_association_name_in(key).to_sym
      association_reflection = model.class.reflect_on_association(association_name)
      association_reflection.macro
    end

    ATTRIBUTES_KEY_REGEXP = /^(.+)_attributes$/

    def has_many_association_attrs?(key)
      key =~ ATTRIBUTES_KEY_REGEXP
    end

    def find_association_name_in(key)
      ATTRIBUTES_KEY_REGEXP.match(key)[1]
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